# Contributing

Thanks for helping improve `legal-extract`.

This repo is for Brazilian legal PDF extraction workflows, dashboards,
fact-checking, and parecer generation. Contributions should improve source
traceability, output quality, documentation clarity, or public-safe examples.

## Good first contributions

- Improve README setup or usage instructions.
- Add synthetic examples of supported document types.
- Improve JSON schema documentation.
- Improve dashboard or PDF template accessibility.
- Add validation notes for source page references.

## Safety boundaries

- Do not commit real private case files, CPFs, RGs, addresses, party names, or
  confidential legal documents.
- Use synthetic or explicitly public-safe examples.
- Do not claim legal advice or guaranteed legal correctness.
- Keep generated outputs source-traceable with page references.

## Accessibility expectations

- Use clear headings and descriptive links.
- Do not communicate confidence or status through color alone.
- Keep tables readable in Markdown, HTML, and PDF outputs.
- Preserve source references in JSON and reports.

## Pull request checklist

- [ ] I used synthetic or public-safe examples.
- [ ] I avoided private case data and credentials.
- [ ] I preserved source traceability.
- [ ] I checked relevant accessibility expectations from [ACCESSIBILITY.md](ACCESSIBILITY.md).
- [ ] I updated docs if user-facing behavior changed.
