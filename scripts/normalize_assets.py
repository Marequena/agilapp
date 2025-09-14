#!/usr/bin/env python3
from pathlib import Path
import re

ASSETS_DIR = Path('assets/figma')

def normalize():
    files = sorted([f for f in ASSETS_DIR.iterdir() if f.is_file()])
    mapping = {}
    seen = {}
    for f in files:
        base = f.name.rsplit('-',1)[0]
        # remove trailing spaces
        candidate = re.sub(r'\s+$','',base)
        # normalize to ascii-ish
        candidate = re.sub(r'[^0-9a-zA-Z_]', '_', candidate)
        # ensure uniqueness
        count = seen.get(candidate,0)
        if count==0:
            new_name = f"{candidate}{f.suffix}"
        else:
            new_name = f"{candidate}_{count}{f.suffix}"
        seen[candidate]=count+1
        mapping[str(f)] = str(ASSETS_DIR / new_name)
    # perform renames
    for old,new in mapping.items():
        Path(old).rename(new)
        print('Renamed', old, '->', new)
    return mapping

if __name__=='__main__':
    mapping=normalize()
    print('Done')
