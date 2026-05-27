# Contributing to Profile Coach

Thank you for your interest in contributing. This project is a Flutter desktop/mobile app for LinkedIn profile coaching (import, AI drafts, compare, scoring).

## Before you start

- Read the [README](README.md) and [docs/RELEASE.md](docs/RELEASE.md)
- License: [MIT](LICENSE) — your contributions will be under the same license
- Security issues: see [SECURITY.md](SECURITY.md) (no public issues for vulnerabilities)

## Development setup

Requirements:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- macOS for macOS builds; Windows for Windows builds; any OS for Android APK

```bash
git clone <your-fork-url>
cd linkedin
flutter pub get
./run.sh          # macOS / Linux
# run.bat         # Windows
```

Checks before opening a PR:

```bash
flutter analyze
flutter test
```

Regenerate icons after changing `assets/branding/`:

```bash
python3 tool/generate_app_icons_pillow.py
```

Regenerate user-guide comparison screenshots:

```bash
python3 tool/generate_doc_screenshots.py
```

Regenerate localizations after editing `lib/l10n/*.arb`:

```bash
flutter gen-l10n
```

## Pull requests

1. Fork the repository and create a branch from `main` (`feature/…` or `fix/…`)
2. Keep changes focused — one concern per PR
3. Update **en / ru / es** strings in `lib/l10n/` when adding user-visible text
4. Add or update tests when changing logic (`test/`)
5. Ensure CI passes (`.github/workflows/ci.yml`)

Describe in the PR:

- What changed and why
- How you tested (platforms)
- Screenshots for UI changes (optional but helpful)

## Code style

- Follow existing patterns in `lib/` (repository → services → screens)
- Prefer localized strings over hardcoded UI text
- Do not commit API keys, `.env`, or personal profile databases

## Releases

Maintainers cut releases via git tags (`v1.0.0`). See [docs/RELEASE.md](docs/RELEASE.md). Contributors do not need to run release workflows unless asked.

## Questions

Open a [GitHub Discussion](https://github.com/alexar76/linked-in-profile-coach/discussions) or an issue labeled `question`.
