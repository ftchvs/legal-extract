# Accessibility

`legal-extract` is documentation and workflow guidance for extracting structured
data from Brazilian legal PDFs and generating dashboards and parecer PDFs.
Accessibility work in this repo focuses on readable outputs, source-traceable
data, navigable dashboards, and clear documentation.

## What we aim for

- Markdown docs use clear headings and descriptive links.
- Generated dashboards should be keyboard navigable where practical.
- Dashboard sections should not rely on color alone.
- Generated PDFs should have clear heading structure and readable tables.
- JSON output should preserve source page references for verification.
- Examples should use synthetic or public-safe legal data only.

## Reporting accessibility issues

Please open an accessibility issue if you find:

- generated dashboards or PDFs that are hard to navigate
- missing text alternatives around charts, tables, or visual markers
- color-only status or confidence indicators
- confusing heading order or link text
- output that is difficult to use with assistive technology

Include the command, output type, browser/PDF reader, operating system, assistive
technology, and a synthetic reproduction when relevant. Do not include private
case data, CPFs, process details, or confidential documents.

## Contribution expectations

Docs and templates should preserve readable headings, tables, labels, and
source references. Use synthetic examples unless the source is explicitly public
and safe to include.
