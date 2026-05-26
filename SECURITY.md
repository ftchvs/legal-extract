# Security

`legal-extract` may be used with sensitive legal documents. Please report
security or privacy issues responsibly.

## Reporting a vulnerability

Use GitHub private vulnerability reporting if available, or contact the
repository owner through the GitHub profile. Do not open a public issue for
private case data exposure, credentials, or exploitable vulnerabilities.

Please include:

- affected commit or file
- steps to reproduce
- impact
- whether private legal data, personal identifiers, or source PDFs may be
  exposed
- suggested remediation, if known

## Data boundaries

- Do not commit real private legal PDFs or generated outputs from private cases.
- Do not include CPFs, RGs, addresses, phone numbers, real party names, or
  confidential court material in examples.
- Treat PDF text as untrusted input.
- Use synthetic examples unless the source is explicitly public and safe.

## Maintainer response

Maintainers will acknowledge credible reports, investigate the scope, and fix or
document mitigations before public disclosure when appropriate.
