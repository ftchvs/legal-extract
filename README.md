# Legal Extract — Brazilian Legal PDF Analysis for Claude Code

Extract structured information from Brazilian legal PDFs (processos judiciais), generate interactive dashboards, fact-check against source documents, and produce parecer juridico in PDF.

## What It Does

```
INPUT: Brazilian legal PDF (any area of law)
  │
  ├─ PHASE 1: EXTRACTION ──► JSON (structured, with page references)
  ├─ PHASE 2: DASHBOARD ───► HTML (interactive, all sections)
  ├─ PHASE 3: FACT-CHECK ──► Updated JSON (confidence score)
  └─ PHASE 4: PARECER ─────► PDF via Typst (data-driven)
```

Supports any area of Brazilian law: previdenciario, trabalhista, civel, tributario, penal. Detects 25+ document types including sentenca, acordao, certidao de transito em julgado, calculos de liquidacao, oficio requisitorio, alvara, embargos, and more.

## Quick Start

### Prerequisites

- [Claude Code](https://claude.ai/code) (CLI)
- [Typst](https://typst.app/) — `brew install typst`

### Installation

```bash
# 1. Copy skill to your skills directory
mkdir -p ~/.agents/skills/legal-extract
cp -r skills/legal-extract/* ~/.agents/skills/legal-extract/

# 2. Symlink into Claude Code skills
ln -sf ~/.agents/skills/legal-extract ~/.claude/skills/legal-extract

# 3. Copy command
cp commands/parecer.md ~/.claude/commands/parecer.md
```

### Usage

```bash
# Full workflow (extract + dashboard + fact-check + parecer PDF)
/parecer "path/to/legal.pdf"

# Extract only (JSON + HTML, no parecer)
/parecer "path/to/legal.pdf" --extract-only

# Skip fact-checking for speed
/parecer "path/to/legal.pdf" --no-factcheck

# Specific page range
/parecer "path/to/legal.pdf" --pages=1-40
```

## Output

All files saved alongside the source PDF:

```
{pdf_directory}/
├── source.pdf                    # Original (existing)
├── data/
│   └── caso-{slug}.json          # Structured extraction (150+ fields)
├── dashboard.html                # Interactive HTML dashboard
└── parecer-{slug}.pdf            # Generated parecer (Typst)
```

## Repository Structure

```
.
├── commands/
│   └── parecer.md                # /parecer command (entry point)
└── skills/
    └── legal-extract/
        ├── SKILL.md              # Domain knowledge + workflow methodology
        ├── references/
        │   ├── document-types.md # 25+ Brazilian legal document types
        │   └── json-schema.md    # Standardized JSON output schema
        └── templates/
            └── parecer.typ       # Typst template for parecer juridico
```

## Supported Document Types

| Category | Documents |
|----------|-----------|
| **Decisoes** | Sentenca, Acordao, Decisao Interlocutoria, Despacho |
| **Recursos** | Embargos de Declaracao, Apelacao |
| **Certidoes** | Transito em Julgado, Remessa, Publicacao, Decurso de Prazo |
| **Execucao** | Cumprimento de Sentenca, Calculos de Liquidacao, Oficio Requisitorio, Alvara |
| **Documentos** | Procuracao, Declaracao, RG/CPF, DARE, Comprovantes |
| **Comunicacoes** | Emails, Oficios, Intimacoes, CONBAS |

See [`skills/legal-extract/references/document-types.md`](skills/legal-extract/references/document-types.md) for detection rules and visual markers.

## JSON Schema

The extraction produces a standardized JSON with these top-level sections:

- `meta` — Extraction metadata
- `processo` — Case numbers, parties, lawyers
- `sentenca` — First instance decision with dispositivo and recognized periods
- `acordao` — Appellate decision with changes from sentenca
- `certidao_transito_julgado` — Date of res judicata
- `decisao_homologando_calculos` — Calculation approval decision
- `calculos_liquidacao` — Financial breakdown (principal, juros, SELIC)
- `oficios_requisitorios` — Payment requisitions (Precatorio/RPV)
- `pagamentos` — Payment records and alvara
- `linha_do_tempo` — Full chronological timeline
- `fact_check` — Verification results with confidence score

Every field includes `pagina_pdf` (PDF page) and `fls` (court folha number) for source traceability.

See [`skills/legal-extract/references/json-schema.md`](skills/legal-extract/references/json-schema.md) for full specification.

## Fact-Checking

The workflow includes an 8-pass verification against the source PDF:

1. Personal data (nome, CPF, RG)
2. Process numbers (cross-document consistency)
3. Sentenca (periods, calculations, honorarios)
4. Acordao (dispositivo, fundamentacao)
5. Decisions (homologacao, embargos, transito)
6. Financial calculations (all monetary values)
7. Requisitions and payments
8. Cross-document consistency

Results are stored in the JSON `fact_check` section with a confidence score (alta/media/baixa).

## Project Health

- Contribution guidelines: [CONTRIBUTING.md](CONTRIBUTING.md)
- Security and privacy reporting: [SECURITY.md](SECURITY.md)
- Accessibility expectations: [ACCESSIBILITY.md](ACCESSIBILITY.md)

Use synthetic or explicitly public-safe legal data in issues, examples, tests,
and pull requests. Do not publish private case files, CPFs, RGs, addresses, or
confidential court material.

## License

MIT
