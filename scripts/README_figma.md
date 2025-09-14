Figma fetcher

Requisitos:
- Python 3
- pip install requests

Uso:

```bash
export FIGMA_TOKEN=your_figma_personal_token
export FIGMA_FILE_KEY=your_figma_file_key
python3 scripts/figma_fetch.py --out assets/figma
```

El script listará frames del archivo Figma y descargará miniaturas PNG en `assets/figma`.
