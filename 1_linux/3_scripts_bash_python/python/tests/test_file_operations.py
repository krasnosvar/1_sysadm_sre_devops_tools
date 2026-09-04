from __future__ import annotations

import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path

PYTHON_ROOT = Path(__file__).parents[1]


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


rename_extensions = load_module(
    "rename_extensions", PYTHON_ROOT / "rename_extensions.py"
)
text_search = load_module("text_search", PYTHON_ROOT / "text_search.py")


class RenameExtensionsTest(unittest.TestCase):
    def test_preview_does_not_change_files_and_apply_renames(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            source = root / "report.old.log"
            source.write_text("result\n", encoding="utf-8")

            operations = rename_extensions.build_plan(
                root, ".old.log", ".log", False, False
            )

            self.assertEqual(operations[0].status, "planned")
            self.assertTrue(source.exists())
            rename_extensions.apply_plan(operations)
            self.assertEqual(operations[0].status, "renamed")
            self.assertEqual((root / "report.log").read_text(), "result\n")

    def test_existing_destination_blocks_every_rename(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "one.jpeg").write_text("one", encoding="utf-8")
            (root / "one.jpg").write_text("existing", encoding="utf-8")
            (root / "two.jpeg").write_text("two", encoding="utf-8")

            operations = rename_extensions.build_plan(
                root, ".jpeg", ".jpg", False, False
            )
            rename_extensions.apply_plan(operations)

            self.assertEqual(
                [operation.status for operation in operations],
                ["conflict", "blocked"],
            )
            self.assertTrue((root / "two.jpeg").exists())
            self.assertEqual((root / "one.jpg").read_text(), "existing")

    def test_recursive_plan_skips_repository_metadata(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "visible.old").write_text("visible", encoding="utf-8")
            (root / ".git").mkdir()
            (root / ".git" / "internal.old").write_text("internal", encoding="utf-8")

            operations = rename_extensions.build_plan(
                root, ".old", ".new", True, False
            )

            self.assertEqual([item.source.name for item in operations], ["visible.old"])

    def test_duplicate_destination_blocks_every_rename(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "report.JPEG").write_text("upper", encoding="utf-8")
            (root / "report.jpeg").write_text("lower", encoding="utf-8")

            operations = rename_extensions.build_plan(
                root, ".jpeg", ".jpg", False, True
            )
            rename_extensions.apply_plan(operations)

            self.assertEqual(
                [operation.status for operation in operations],
                ["conflict", "conflict"],
            )
            self.assertFalse((root / "report.jpg").exists())
            self.assertTrue((root / "report.JPEG").exists())
            self.assertTrue((root / "report.jpeg").exists())


class TextSearchTest(unittest.TestCase):
    def test_fixed_word_search_skips_binary_and_default_directories(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "app.log").write_text(
                "Connection refused\nconnection-refused is different\n",
                encoding="utf-8",
            )
            (root / "binary.log").write_bytes(b"connection refused\0data")
            (root / ".git").mkdir()
            (root / ".git" / "ignored.log").write_text(
                "connection refused\n", encoding="utf-8"
            )
            expression = text_search.compile_query(
                "connection refused", regex=False, word=True, ignore_case=True
            )

            matches, summary = text_search.search_files(
                root,
                expression,
                ["*.log"],
                text_search.DEFAULT_EXCLUDED_DIRECTORIES,
                1024,
                100,
                False,
            )

            self.assertEqual(len(matches), 1)
            self.assertEqual(matches[0].line, 1)
            self.assertEqual(summary.skipped_binary, 1)
            self.assertEqual(summary.scanned_files, 1)

    def test_regex_search_can_redact_matching_line(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "deployment.yaml").write_text(
                "image: example/api:latest\n", encoding="utf-8"
            )
            expression = text_search.compile_query(
                r"image:.*:latest$", regex=True, word=False, ignore_case=False
            )

            matches, _ = text_search.search_files(
                root,
                expression,
                ["*.yaml"],
                text_search.DEFAULT_EXCLUDED_DIRECTORIES,
                1024,
                100,
                True,
            )

            self.assertEqual(len(matches), 1)
            self.assertIsNone(matches[0].text)


if __name__ == "__main__":
    unittest.main()
