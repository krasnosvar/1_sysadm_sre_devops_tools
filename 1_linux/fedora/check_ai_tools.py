"""Offline mode checks: fake CLIs, no installers or network calls."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parent / '5_ai_tools.sh'


class Modes(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.log = self.root / 'calls'
        self.env = dict(os.environ, PATH=str(self.root), CALL_LOG=str(self.log))
        for command in ('dirname', 'realpath', 'cat', 'jq'):
            (self.root / command).symlink_to(shutil.which(command))
        for cli in ('codex', 'claude', 'agy', 'git', 'node'):
            self.stub(cli)

    def stub(self, cli):
        body = '''#!/bin/bash
printf '%s\\n' "${0##*/} $*" >> "$CALL_LOG"
if [ "${FAIL_CLI:-}" = "${0##*/}" ]; then exit 42; fi
if [ "${EMPTY_PLUGINS:-}" = yes ]; then
  case "$*" in
    'plugin marketplace list --json')
      if [ "${0##*/}" = codex ]; then echo '{"marketplaces":[]}'; else echo '[]'; fi
      exit ;;
    'plugin list'*)
      if [ "${0##*/}" = codex ]; then echo '{"installed":[]}'; else echo '[]'; fi
      exit ;;
    'plugin marketplace add '*|'plugin add '*|'plugin install '*) exit 0 ;;
  esac
fi
case "$*" in
  --version) echo test-version ;;
  'plugin marketplace list --json')
    if [ "${0##*/}" = codex ]; then
      echo '{"marketplaces":[{"name":"ponytail"}]}'
    else
      echo '[{"name":"ponytail"},{"name":"claude-plugins-official"}]'
    fi ;;
  'plugin list'*)
    if [ "${BAD_JSON:-}" = yes ]; then echo invalid; exit; fi
    case "${0##*/}" in
      codex) echo '{"installed":[{"pluginId":"ponytail@ponytail","enabled":false},{"pluginId":"superpowers@openai-curated-remote","enabled":false}]}' ;;
      claude) echo '[{"id":"ponytail@ponytail","scope":"user","enabled":false},{"id":"superpowers@claude-plugins-official","scope":"user","enabled":false},{"id":"context7@claude-plugins-official","scope":"user"},{"id":"playwright@claude-plugins-official","scope":"user"}]' ;;
      agy) echo '[{"name":"ponytail","enabled":false},{"name":"superpowers","enabled":false}]' ;;
    esac ;;
  *) exit 99 ;;
esac
'''
        p = self.root / cli
        p.write_text(body)
        p.chmod(0o755)

    def run_mode(self, *args):
        return subprocess.run(['/bin/bash', str(SCRIPT), *args], env=self.env,
                              text=True, capture_output=True)

    def calls(self):
        return self.log.read_text() if self.log.exists() else ''

    def test_help_and_invalid_arguments_do_not_run_tools(self):
        self.assertEqual(self.run_mode('--help').returncode, 0)
        self.assertNotEqual(self.run_mode('--typo').returncode, 0)
        self.assertNotEqual(self.run_mode('--status', '--plugins-only').returncode, 0)
        self.assertEqual(self.calls(), '')

    def test_status_only_reads_versions_and_plugins(self):
        result = self.run_mode('--status')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('gemini: not installed', result.stdout)
        for call in self.calls().splitlines():
            self.assertTrue(call.endswith('--version') or call.endswith('plugin list --json'), call)

    def test_status_continues_after_failure_but_returns_error(self):
        self.env['FAIL_CLI'] = 'codex'
        self.assertNotEqual(self.run_mode('--status').returncode, 0)
        self.assertIn('agy plugin list', self.calls())

    @unittest.skipIf(os.geteuid() == 0, 'Install modes intentionally reject root')
    def test_plugins_preserve_existing_disabled_plugins(self):
        result = self.run_mode('--plugins-only')
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(len(self.calls().splitlines()), 6)
        self.assertNotIn('install', self.calls())

    @unittest.skipIf(os.geteuid() == 0, 'Install modes intentionally reject root')
    def test_missing_prerequisite_prevents_all_plugin_changes(self):
        (self.root / 'node').unlink()
        self.assertNotEqual(self.run_mode('--plugins-only').returncode, 0)
        self.assertEqual(self.calls(), '')

    @unittest.skipIf(os.geteuid() == 0, 'Install modes intentionally reject root')
    def test_invalid_plugin_data_stops_before_other_clients(self):
        self.env['BAD_JSON'] = 'yes'
        self.assertNotEqual(self.run_mode('--plugins-only').returncode, 0)
        self.assertNotIn('claude', self.calls())

    @unittest.skipIf(os.geteuid() == 0, 'Install modes intentionally reject root')
    def test_fresh_install_includes_superpowers_for_each_client(self):
        self.env['EMPTY_PLUGINS'] = 'yes'
        result = self.run_mode('--plugins-only')
        self.assertEqual(result.returncode, 0, result.stderr)
        calls = self.calls()
        for command in (
            'codex plugin add superpowers@openai-curated-remote',
            'claude plugin install superpowers@claude-plugins-official --scope user',
            'agy plugin install https://github.com/obra/superpowers',
        ):
            self.assertIn(command, calls)
        self.assertEqual(len(calls.splitlines()), 17)

    def test_dnf_update_exit_codes(self):
        block = SCRIPT.read_text().split('dnf_status=0', 1)[1].split('dnf_install_if_missing', 1)[0]
        for status, expected in ((0, 0), (100, 0), (1, 1)):
            result = subprocess.run(
                ['/bin/bash', '-c', 'set -e; die() { exit 1; }; '
                 f'sudo() {{ return {status}; }}; dnf_status=0' + block],
                capture_output=True)
            self.assertEqual(result.returncode, expected)


if __name__ == '__main__':
    unittest.main()
