#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SAMPLE_JSON="$ROOT_DIR/examples/synthetic-case/data/caso-sintetico.json"
OUT_DIR="${TMPDIR:-/tmp}/legal-extract-check"
OUT_PDF="$OUT_DIR/parecer-sintetico.pdf"

require() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

require jq

mkdir -p "$OUT_DIR"

jq empty "$SAMPLE_JSON"

jq -e '
  .meta.versao and
  .processo.numero_principal and
  .processo.partes.autor.fonte.paginas_pdf and
  .sentenca.paginas_pdf and
  .certidao_transito_julgado.data_transito and
  .calculos_liquidacao.resumo_valores.totalizacao.total_geral and
  (.linha_do_tempo | type == "array") and
  .fact_check.confianca_geral
' "$SAMPLE_JSON" >/dev/null

echo "JSON fixture OK: $SAMPLE_JSON"

if command -v typst >/dev/null 2>&1; then
  typst compile \
    --root / \
    --input data-path="$SAMPLE_JSON" \
    "$ROOT_DIR/skills/legal-extract/templates/parecer.typ" \
    "$OUT_PDF" >/dev/null
  echo "Typst template OK: $OUT_PDF"
else
  echo "Typst not installed; skipped PDF compile"
fi
