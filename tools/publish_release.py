"""Complete the existing public alpha release using the runner's GitHub token.

Never moves an existing version tag or replaces an existing asset. A changed
asset with the same name causes an error. Only contents write permission is used.
"""
from pathlib import Path
import hashlib
import json
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def gh(*args):
    return subprocess.check_output(['gh', *args], text=True, encoding='utf-8').strip()


def main():
    release = json.loads((ROOT/'release.json').read_text(encoding='utf-8'))
    tag = release['tag']
    # This version was already published by the maintainer. Require that release
    # to exist, preserving its tag target and all previously uploaded files.
    current = json.loads(gh('release', 'view', tag, '--json', 'assets,isDraft,url'))
    if current['isDraft']:
        raise SystemExit('Expected the existing published alpha, found a draft')
    known = {asset['name']: asset for asset in current['assets']}
    for path in sorted((ROOT/'dist').iterdir()):
        if path.name in known:
            # Always compare the downloaded bytes; older gh versions may omit digest.
            raw = subprocess.check_output(['gh','release','download',tag,'--pattern',path.name,'--output','-'])
            if hashlib.sha256(raw).digest() != hashlib.sha256(path.read_bytes()).digest():
                raise SystemExit(f'Existing release asset differs: {path.name}; refusing to replace it')
            print(f'Preserved matching asset: {path.name}', flush=True)
        else:
            gh('release','upload',tag,str(path))
            print(f'Uploaded: {path.name}', flush=True)
    gh('release','edit',tag,'--title','1885 Start – v1.0.0-alpha – Windows-Komplettpaket',
       '--notes-file',str(ROOT/'release-notes.md'),'--prerelease')
    print(current['url'])


if __name__ == '__main__':
    main()
