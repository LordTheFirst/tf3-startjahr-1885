"""Verify the frozen alpha payload and reproduce its complete Windows ZIP.

Uses the Python standard library. Does not read or change an installed game.
"""
from pathlib import Path
import argparse
import hashlib
import json
import shutil
import zipfile

ROOT = Path(__file__).resolve().parents[1]


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='Verify existing dist files without rebuilding')
    args = parser.parse_args()
    release = json.loads((ROOT / 'release.json').read_text(encoding='utf-8'))
    package = ROOT / 'package'
    expected = {item['name'] for item in release['layout']}
    actual = {path.relative_to(package).as_posix() for path in package.rglob('*') if path.is_file()}
    if actual != expected:
        raise SystemExit(f'Package file list differs. Added: {actual-expected}; missing: {expected-actual}')
    for item in release['layout']:
        path = package / item['name']
        if sha256(path) != item['sha256']:
            raise SystemExit(f'Release payload differs: {item["name"]}')
        if path.suffix in {'.json', '.lua', '.ps1', '.md'}:
            raw = path.read_bytes()
            if raw.startswith(b'\xef\xbb\xbf'):
                raise SystemExit(f'Unexpected UTF-8 BOM: {path.name}')
            raw.decode('utf-8')
        if path.suffix == '.json':
            json.loads(path.read_text(encoding='utf-8'))
    metadata = json.loads((package/'start_year_1885/_metadata/modinfo.json').read_text(encoding='utf-8'))
    mod = json.loads((package/'start_year_1885/mod.json').read_text(encoding='utf-8'))
    if mod['modId'] != 'start_year_1885' or mod['revision'] != release['mod_revision']:
        raise SystemExit('Unexpected mod ID or revision')
    for text in (metadata, metadata['localization']['de']):
        if len(text['name']) > 32 or len(text['summary']) > 100:
            raise SystemExit('Metadata title or summary is too long')
    plan = json.loads((package/'patch.json').read_text(encoding='utf-8'))
    if (plan['checked_windows_build'], plan['start_year'], plan['year_step']) != (40423, 1885, 5):
        raise SystemExit('Unexpected patch target')
    pdf = ROOT / 'docs/TF3_1885_Anleitung_DE.pdf'
    if pdf.read_bytes() != (package/'anleitung_de.pdf').read_bytes():
        raise SystemExit('Standalone PDF differs from the packaged manual')
    output = ROOT / 'dist'
    archive_path = output / release['asset']
    if not args.check:
        output.mkdir(exist_ok=True)
        with zipfile.ZipFile(archive_path, 'w') as archive:
            for item in release['layout']:
                info = zipfile.ZipInfo(item['name'], tuple(item['date_time']))
                info.compress_type = item['compress_type']
                info.create_system = item['create_system']
                info.external_attr = item['external_attr']
                archive.writestr(info, (package / item['name']).read_bytes())
        shutil.copyfile(pdf, output / pdf.name)
        checksums = ''.join(f'{sha256(path)}  {path.name}\n' for path in (archive_path, output/pdf.name))
        (output/'SHA256SUMS.txt').write_text(checksums, encoding='utf-8', newline='\n')
    if sha256(archive_path) != release['archive_sha256']:
        raise SystemExit('Generated archive differs from the published alpha; do not replace the release asset')
    with zipfile.ZipFile(archive_path) as archive:
        if archive.testzip() is not None or archive.namelist() != [item['name'] for item in release['layout']]:
            raise SystemExit('Invalid ZIP contents')
    expected_checksums = (ROOT/'checksums/SHA256SUMS.txt').read_text(encoding='utf-8')
    if (output/'SHA256SUMS.txt').read_text(encoding='utf-8') != expected_checksums:
        raise SystemExit('Release checksum list differs')
    for line in expected_checksums.splitlines():
        checksum, name = line.split('  ', 1)
        if Path(name).name != name or sha256(output/name) != checksum:
            raise SystemExit(f'Asset checksum mismatch: {name}')
    print(f'PASS: {len(expected)} payload files, metadata, PDF and byte-identical ZIP verified.')
    print(f'{archive_path.name}: {sha256(archive_path)}')


if __name__ == '__main__':
    main()
