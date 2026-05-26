# Legal Extract

Brazilian legal PDF extraction workflow for Claude Code: structured JSON,
interactive dashboards, source-traceable fact-checking, and Typst-based parecer
PDF generation.

This repository is a public-safe sample. It ships the skill, slash command,
schema references, Typst template, and a synthetic fixture so contributors can
inspect and validate the workflow without private legal files.

> Legal and privacy note: this project is an extraction and drafting aid, not
> legal advice. Do not publish private case files, CPFs, RGs, addresses,
> signatures, bank details, or confidential court material.

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
- [Typst](https://typst.app/) for parecer PDF generation

On macOS:

```bash
brew install typst jq
```

`jq` is only required for the sample validation script.

### Install The Skill

```bash
scripts/install.sh
```

The installer copies:

- `skills/legal-extract/` → `~/.agents/skills/legal-extract/`
- symlink → `~/.claude/skills/legal-extract`
- `commands/parecer.md` → `~/.claude/commands/parecer.md`

Manual installation is still possible if you prefer copying files yourself.

### Validate The Public Sample

```bash
scripts/check-sample.sh
```

This validates `examples/synthetic-case/data/caso-sintetico.json` and compiles
the Typst parecer template when `typst` is installed.

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

Use `--extract-only` first when evaluating a new document. Run full parecer
generation only after the extracted JSON has usable source references.

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

Generated outputs from private PDFs should stay outside this repository.

## Repository Structure

```
.
├── commands/
│   └── parecer.md                # /parecer command (entry point)
├── examples/
│   └── synthetic-case/           # public-safe sample JSON fixture
├── scripts/
│   ├── check-sample.sh           # JSON + Typst template smoke test
│   └── install.sh                # local Claude Code skill installer
└── skills/
    └── legal-extract/
        ├── SKILL.md              # Domain knowledge + workflow methodology
        ├── references/
        │   ├── document-types.md # 25+ Brazilian legal document types
        │   └── json-schema.md    # Standardized JSON output schema
        └── templates/
            └── parecer.typ       # Typst template for parecer juridico
```

## Public-Safe Sample

The repository intentionally does not include a real legal PDF. Real case PDFs
often contain names, CPFs, RGs, signatures, addresses, bank information, and
confidential filings.

Use the synthetic fixture for template and schema checks:

```bash
examples/synthetic-case/data/caso-sintetico.json
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

## Validation Checklist

Before opening a pull request:

- Run `scripts/check-sample.sh`.
- Confirm examples use synthetic or explicitly public-safe data.
- Confirm new extracted fields include page/folha source references.
- Confirm README, schema docs, and command docs are updated for user-facing
  behavior changes.
- Do not commit generated outputs from private PDFs.

## Project Health

- Contribution guidelines: [CONTRIBUTING.md](CONTRIBUTING.md)
- Security and privacy reporting: [SECURITY.md](SECURITY.md)
- Accessibility expectations: [ACCESSIBILITY.md](ACCESSIBILITY.md)

Use synthetic or explicitly public-safe legal data in issues, examples, tests,
and pull requests. Do not publish private case files, CPFs, RGs, addresses, or
confidential court material.

## License

MIT
