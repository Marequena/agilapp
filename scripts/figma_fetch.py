#!/usr/bin/env python3
"""
Simple Figma fetcher: lista frames de un archivo y descarga thumbnails.
Requiere: pip install requests
Uso:
  export FIGMA_TOKEN=...
  export FIGMA_FILE_KEY=...
  python3 scripts/figma_fetch.py --out assets/figma
"""
import os
import sys
import argparse
import requests
from pathlib import Path

FIGMA_API = "https://api.figma.com/v1"


def list_frames(token: str, file_key: str):
    url = f"{FIGMA_API}/files/{file_key}"
    headers = {"X-Figma-Token": token}
    r = requests.get(url, headers=headers)
    r.raise_for_status()
    data = r.json()
    frames = []

    def walk(node):
        if node.get('type') == 'FRAME':
            frames.append({'id': node['id'], 'name': node.get('name')})
        for child in node.get('children', []):
            walk(child)

    walk(data['document'])
    return frames


def download_thumbnail(token: str, file_key: str, node_id: str, scale: float = 1.0, fmt: str = 'png') -> bytes:
    url = f"{FIGMA_API}/images/{file_key}?ids={node_id}&format={fmt}&scale={scale}"
    headers = {"X-Figma-Token": token}
    r = requests.get(url, headers=headers)
    r.raise_for_status()
    data = r.json()
    image_url = data.get('images', {}).get(node_id)
    if not image_url:
        raise RuntimeError('No image URL returned')
    img = requests.get(image_url)
    img.raise_for_status()
    return img.content


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--out', required=True, help='Output directory')
    parser.add_argument('--token', default=os.environ.get('FIGMA_TOKEN'), help='Figma token (or FIGMA_TOKEN env)')
    parser.add_argument('--file', default=os.environ.get('FIGMA_FILE_KEY'), help='Figma file key (or FIGMA_FILE_KEY env)')
    args = parser.parse_args()

    if not args.token or not args.file:
        print('FIGMA token and file key are required (use env vars or flags).', file=sys.stderr)
        sys.exit(1)

    outdir = Path(args.out)
    outdir.mkdir(parents=True, exist_ok=True)

    frames = list_frames(args.token, args.file)
    print(f'Found {len(frames)} frames')

    for f in frames:
        safe_name = ''.join(c if c.isalnum() or c in (' ', '-', '_') else '_' for c in f['name']).strip()
        filename = outdir / f"{safe_name}-{f['id']}.png"
        print('Downloading', f['name'], '->', filename)
        try:
            data = download_thumbnail(args.token, args.file, f['id'], scale=2.0)
            with open(filename, 'wb') as fh:
                fh.write(data)
        except Exception as e:
            print('Failed to download', f['name'], e, file=sys.stderr)


if __name__ == '__main__':
    main()
