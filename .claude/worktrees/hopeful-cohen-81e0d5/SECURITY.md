# Security Policy

## Supported versions

Security fixes are provided for the latest release tag only.

| Version | Supported |
| ------- | --------- |
| Latest release (`v*`) | Yes |
| Older releases | No |
| `main` branch (unreleased) | Best effort |

## Reporting a vulnerability

**Please do not open a public GitHub issue for security problems.**

Send a private report with:

- Description of the issue and impact
- Steps to reproduce
- Affected version / platform (macOS, Windows, Android)
- Your GitHub username (optional), if you want credit

Use one of:

1. **GitHub Security Advisories** — *Security* → *Report a vulnerability* on the repository (preferred)
2. **Email** — replace with your security contact before publishing the repo

We aim to acknowledge reports within **5 business days** and to share a remediation plan or fix timeline when confirmed.

## Scope notes

- This app stores profile text and settings **locally** on the device (SQLite). It does not upload your LinkedIn password.
- **API keys** (LLM providers) are stored in local `app_settings`. Do not commit keys or share database files publicly.
- LinkedIn profile import is manual or best-effort HTTP; treat imported data as sensitive.

## Safe disclosure

We appreciate responsible disclosure. We will not pursue legal action against researchers who follow this policy in good faith.
