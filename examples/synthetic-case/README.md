# Synthetic Legal Case Example

This directory contains public-safe fixture data for testing the Legal Extract
workflow without private PDFs or real personal identifiers.

## Files

- `data/caso-sintetico.json` — complete synthetic extraction output that matches
  the documented schema.

## Why There Is No PDF

Real legal PDFs often contain private party names, CPF/RG numbers, addresses,
court filings, signatures, and payment details. This fixture intentionally starts
from synthetic JSON so contributors can validate templates and examples without
handling private case material.

## Validate The Fixture

From the repository root:

```bash
scripts/check-sample.sh
```

The check validates JSON syntax, required top-level fields, and Typst PDF
compilation when `typst` is installed.
