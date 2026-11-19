"""Проверка локальных ссылок и примеров без модельных/сетевых вызовов."""
from pathlib import Path
import argparse
import json
import re
import subprocess
import tempfile
import tomllib

import yaml


def check(root, allowed=None):
    allowed = (allowed or root).resolve()
    errors = []
    for path in sorted(root.rglob('*')):
        if not path.is_file() or path.suffix not in {'.md', '.json', '.toml'}:
            continue
        raw = path.read_text()
        try:
            if path.suffix == '.json':
                json.loads(raw)
            elif path.suffix == '.toml':
                tomllib.loads(raw)
            else:
                if any(c in raw for c in (chr(0x2013), chr(0x2014))):
                    raise ValueError('запрещённое тире')
                if len(re.findall(r'^```', raw, re.M)) % 2:
                    raise ValueError('незакрытый блок кода')
                if raw.startswith('---\n'):
                    metadata = yaml.safe_load(raw.split('---', 2)[1])
                    for key in ('name', 'description', 'model'):
                        if not isinstance(metadata.get(key), str):
                            raise ValueError(f'нет строкового поля {key}')
                for target in re.findall(r'\[[^\]]*\]\(([^)]+)\)', raw):
                    if target.startswith(('https://', 'http://', '#')):
                        continue
                    destination = (path.parent / target.split('#')[0]).resolve()
                    if not destination.is_relative_to(allowed):
                        raise ValueError(f'ссылка вне публикуемой базы: {target}')
                    if not destination.exists():
                        raise ValueError(f'ссылка не существует: {target}')
                for block in re.findall(r'```bash\n(.*?)```', raw, re.S):
                    result = subprocess.run(['bash', '-n'], input=block,
                                            text=True, capture_output=True)
                    if result.returncode:
                        raise ValueError(f'синтаксис Bash: {result.stderr.strip()}')
        except (ValueError, yaml.YAMLError, IndexError, AttributeError) as exc:
            errors.append(f'{path.relative_to(root)}: {exc}')
    return errors


def self_test():
    with tempfile.TemporaryDirectory() as directory:
        root = Path(directory)
        page = root / 'README.md'
        page.write_text('# Тест\n\n[Цель](target.md)\n')
        assert check(root), 'пропущена несуществующая ссылка'
        (root / 'target.md').write_text('# Цель\n')
        assert not check(root)
        page.write_text('[За пределами базы](../README.md)\n')
        assert check(root), 'пропущена ссылка за пределы базы'
        page.write_text('```bash\nif then\n```\n')
        assert check(root), 'пропущен неверный Bash'
        page.write_text('---\nname: [\n---\n')
        assert check(root), 'пропущен неверный YAML'
        page.write_text('```text\nне закрыт\n')
        assert check(root), 'пропущен незакрытый блок'
    print('PASS: проверены отрицательные случаи валидатора')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--self-test', action='store_true')
    args = parser.parse_args()
    if args.self_test:
        self_test()
    base = Path(__file__).resolve().parent
    # ссылки на соседние файлы каталога 4_ai_tools разрешены
    failures = check(base, base.parent)
    if failures:
        raise SystemExit('\n'.join(failures))
    print('PASS: локальные ссылки, форматы, Markdown fences и Bash-синтаксис')
