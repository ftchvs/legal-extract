---
description: Extract structured legal info from Brazilian legal PDFs, generate dashboard + fact-checked JSON + parecer PDF
argument-hint: "<pdf_path>" [--extract-only] [--no-factcheck] [--pages=1-20]
---

# /parecer — Brazilian Legal PDF Analysis

Complete workflow: PDF extraction → JSON → HTML dashboard → fact-check → parecer PDF.

## Context Engineering Skills

This command uses the `legal-extract` skill from `~/.agents/skills/legal-extract/`:

| Resource | Purpose |
|----------|---------|
| [SKILL.md](../skills/legal-extract/SKILL.md) | Extraction methodology, dashboard spec, fact-check protocol |
| [document-types.md](../skills/legal-extract/references/document-types.md) | 25+ Brazilian legal document type detection rules |
| [json-schema.md](../skills/legal-extract/references/json-schema.md) | Standardized JSON output schema |
| [parecer.typ](../skills/legal-extract/templates/parecer.typ) | Typst template for parecer juridico |

## Usage

```bash
/parecer "cases/public-safe-example/processo.pdf"                    # Full workflow
/parecer "cases/public-safe-example/processo.pdf" --extract-only      # JSON + HTML only
/parecer "cases/public-safe-example/processo.pdf" --no-factcheck      # Skip fact-checking
/parecer "cases/public-safe-example/processo.pdf" --pages=1-40        # Page range
```

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `pdf_path` | Yes | Path to the Brazilian legal PDF |
| `--extract-only` | No | Skip parecer PDF generation (phases 1-3 only) |
| `--no-factcheck` | No | Skip ralph-loop fact-checking (phases 1, 2, 4 only) |
| `--pages` | No | Page range to process (e.g., `1-20`, `1,5,10-30`). Default: all |

## Architecture

```
PHASE 0: CONTEXT DISCOVERY
└── Search the local workspace or case directory for prior analyses
    ├── existing data/caso-*.json files for same parties/process numbers
    ├── related dashboards or parecer PDFs in the same case folder
    └── optional local memory/search tools when available

PHASE 1: EXTRACTION (coordinator)
├── Read all PDF pages in batches of 20
├── Detect document types using visual markers (see document-types.md)
├── Build structured JSON per json-schema.md
├── Every field includes pagina_pdf + fls source references
└── Output: {pdf_dir}/data/caso-{slug}.json

PHASE 2: DASHBOARD (background agent)
├── Generate self-contained HTML from JSON
├── Light theme, all sections open, pt-BR
├── 13 sections: header, financeiro, sentença, acórdão, embargos,
│   trânsito, homologação, cálculos, requisitórios, pagamentos,
│   benefício, timeline, verificação
└── Output: {pdf_dir}/dashboard.html

PHASE 3: FACT-CHECK (ralph-loop agent) [skip with --no-factcheck]
├── 8 verification passes against source PDF
│   ├── Pass 1: Dados pessoais (nome, CPF, RG, filiação)
│   ├── Pass 2: Números de processo (consistência)
│   ├── Pass 3: Sentença (períodos, tempo, honorários)
│   ├── Pass 4: Acórdão (dispositivo, fundamentação)
│   ├── Pass 5: Decisões (homologação, embargos, trânsito)
│   ├── Pass 6: Cálculos (todos os valores monetários)
│   ├── Pass 7: Ofícios + Pagamentos (números, valores, datas)
│   └── Pass 8: Consistência cross-document
├── Fix errors directly in JSON
├── Update fact_check section with confidence score
└── Output: updated JSON (confiança: alta/média/baixa)

PHASE 4: PARECER PDF (Typst) [skip with --extract-only]
├── Load template: ~/.agents/skills/legal-extract/templates/parecer.typ
├── Compile: typst compile --root / --input data-path="{pdf_dir}/data/caso-{slug}.json" parecer.typ
├── 5 sections: Partes, Processo, Precatório, Due Diligence, Conclusão
└── Output: {pdf_dir}/parecer-{slug}.pdf
```

## Output Directory

All outputs saved alongside the source PDF:

```
{pdf_directory}/
├── source.pdf                  # Original (existing)
├── data/
│   └── caso-{slug}.json        # Structured extraction (150+ fields)
├── dashboard.html              # Interactive HTML dashboard
└── parecer-{slug}.pdf          # Generated parecer (if not --extract-only)
```

The `{slug}` is derived from the case parties or process number.

## Execution Instructions

### Step 1: Parse arguments

```javascript
const pdfPath = $ARGUMENTS.match(/^"?([^"]+\.pdf)"?/i)?.[1] || $ARGUMENTS.split(' ')[0];
const extractOnly = $ARGUMENTS.includes('--extract-only');
const noFactcheck = $ARGUMENTS.includes('--no-factcheck');
const pagesMatch = $ARGUMENTS.match(/--pages=(\S+)/);
const pageRange = pagesMatch ? pagesMatch[1] : null;
```

### Step 2: Read the `legal-extract` SKILL.md

Load `~/.agents/skills/legal-extract/SKILL.md` for extraction methodology, then load `references/document-types.md` for document detection rules, and `references/json-schema.md` for the output schema.

### Step 3: Execute phases

1. **Phase 0:** Search local workspace/case folder for prior analyses
2. **Phase 1:** Read PDF pages, detect documents, build JSON per schema
3. **Phase 2:** Spawn background agent to generate HTML dashboard from JSON
4. **Phase 3:** If not `--no-factcheck`, spawn ralph-loop agent for 8-pass verification
5. **Phase 4:** If not `--extract-only`, compile parecer PDF via Typst:
   ```bash
   typst compile \
     --root / \
     --input data-path="{pdf_dir}/data/caso-{slug}.json" \
     ~/.agents/skills/legal-extract/templates/parecer.typ \
     {pdf_dir}/parecer-{slug}.pdf
   ```

### Step 4: Report results

Print summary with:
- Documents detected (count by type)
- JSON field count
- Fact-check confidence score
- Output file paths
- Privacy reminder if the PDF appears to contain personal identifiers

## Supported Legal Areas

| Area | Auto-Detected By | Domain-Specific Fields |
|------|-------------------|----------------------|
| Previdenciário | "INSS", "aposentadoria", "tempo de contribuição", "NB" | períodos especiais, benefício, DER, RMI |
| Trabalhista | "CLT", "verbas rescisórias", "FGTS", "Justiça do Trabalho" | verbas, período contratual, rescisão |
| Cível | "danos morais", "indenização", "obrigação de fazer" | danos, obrigações |
| Tributário | "ICMS", "ISS", "contribuição", "Fazenda" | tributo, base cálculo, alíquota |
| Penal | "réu", "denúncia", "pena", "regime" | pena, regime, dosimetria |

The extraction adapts automatically based on detected keywords. Core structure (processo, partes, sentença, acórdão, certidões) is universal.

## Dependencies

- **Typst** (`typst` CLI) — for parecer PDF generation. Install: `brew install typst`
- **Claude Code** — for PDF reading and agent orchestration
- No Python, no MCP servers, no API keys required

## Public-Safe Development Fixture

This repository includes a synthetic JSON fixture for schema and template checks:

```bash
scripts/check-sample.sh
```

Do not use private PDFs, real CPFs/RGs, real party names, bank data, addresses,
or confidential filings in public issues, pull requests, or examples.
