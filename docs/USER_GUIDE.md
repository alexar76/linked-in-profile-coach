# User Guide — Profile Coach

Step-by-step: from install to publishing an improved LinkedIn profile.

> App screenshots (real UI) — [screens/](screens/).  
> Compare illustrations — [images/](images/).  
> Chrome copy helper — [extension/linkedin-coach-helper/](../extension/linkedin-coach-helper/)

---

## 1. Installation

### Option A — prebuilt (recommended)

1. Open [GitHub Releases](https://github.com/alexar76/linked-in-profile-coach/releases).
2. Download the file for your OS:
   - **macOS** — `ProfileCoach-vX.Y.Z-macos.zip` → unzip → move `.app` to Applications.
   - **Windows** — `ProfileCoach-vX.Y.Z-windows-x64.zip` → unzip → run `.exe`.
   - **Android** — `ProfileCoach-vX.Y.Z-android-universal.apk` (allow install from unknown sources).
3. On first launch on macOS, if blocked: *System Settings → Privacy & Security → Open Anyway*.

### Option B — from source

```bash
git clone https://github.com/alexar76/linked-in-profile-coach.git
cd linked-in-profile-coach
chmod +x run.sh && ./run.sh    # macOS / Linux
# run.bat                      # Windows
```

---

## 2. Wizards

### Setup wizard (first launch, 8 steps)

1. App language (EN / RU / ES)
2. Name and **LinkedIn profile URL**
3. Target role and industry
4. Premium positioning template
5. LLM API key (optional)
6. `.docx` resume (optional)
7. Clipboard import (optional)
8. Finish → main app

Re-run: **Settings → Run setup wizard again**.

### Guided analysis wizard (6 steps)

Top bar → **Guided analysis**:

| Step | What happens |
|------|----------------|
| 1. Import | Paste LinkedIn sections or skip |
| 2. AI | Generate AI profile draft |
| 3. Review | Checklist of **all 24 profile sections** (filled / AI) |
| 4. Insights | Run rule-based analysis |
| 5. Publish | Open publish sheet per section |
| 6. Done | Enter main app |

---

## 3. Profile sections (24)

| Group | Sections |
|-------|----------|
| Intro | Headline, About, Location & industry, Contact & links, Open to work |
| Career | Experience, Education, Skills, Certifications, Languages, Courses |
| Proof | Projects, Publications, Patents, Honors, Organizations, Services |
| Social | Featured, Volunteer, Causes, Recommendations, Recommendations given |
| Voice | Activity, Creator & newsletter |

---

## 4. Import from LinkedIn

LinkedIn does **not** grant write access to third-party apps — import is one-way (pull).

### Refresh from LinkedIn (recommended)

**LinkedIn** tab → **Refresh from LinkedIn**:

1. Watch folder (if set in Settings) — newest `.zip` / `.json`
2. Last export file path
3. Public profile URL (partial: headline + about)

A **merge dialog** opens: choose which sections to apply (preview per section). Snapshots are saved automatically before merge.

### LinkedIn data export (full import)

1. linkedin.com → **Settings → Data privacy → Get a copy of your data**
2. Request export including profile + analytics CSVs
3. **LinkedIn** tab → **LinkedIn data export** → select `.zip` or `.json`

### Clipboard

Paste with headers (any section):

```text
HEADLINE:
…

ABOUT:
…

EXPERIENCE:
…

LANGUAGES:
…

HONORS:
…
```

### JSON

Flat keys or nested LinkedIn export JSON → **Import JSON**.

### Chrome extension (optional)

Load `extension/linkedin-coach-helper/` in Chrome → copy section with header → **Import from clipboard**.

### Watch folder (auto-import)

**Settings → LinkedIn sync → Choose watch folder** — drop a new export ZIP; the app prompts to merge when you return.

### History (snapshots)

**LinkedIn → History** — restore a previous profile snapshot before an import.

---

## 5. Overview dashboard

The **Overview** tab shows:

- **Profile completeness** ring and target role
- KPI cards: sections, score, tips, imports, ATS match %
- **Growth dynamics** — completeness over time (from snapshots), evaluator score trend
- **LinkedIn statistics** — profile views, search appearances, etc. (from export analytics CSVs)
- Reminder if last import was 30+ days ago

---

## 6. AI setup (optional)

1. **Settings → AI — API**
2. Provider + API key → **Test connection**
3. **App language** — one language for UI, insights, AI, and scoring

Without a key, local templates are used. After import merge, AI regenerates **only changed sections**.

---

## 7. Generate & compare

1. **Generate AI** (toolbar) — full draft
2. **AI profile** tab — edit sections
3. **Compare** — side by side / diff, similarity %

---

## 8. Scoring & insights

- **Score profile** → **Scoring** tab (evaluator agent)
- **Run analysis** → **Insights** tab (rule-based tips per section)

---

## 9. Publish to LinkedIn (manual)

**Compare → Update on LinkedIn** — copy AI text, open LinkedIn in browser, mark done.

---

## 10. Typical workflow

```text
Setup wizard → Import (export ZIP or Refresh) → Merge sections →
Overview (dynamics) → Guided analysis → Generate AI → Compare →
Score profile → Publish on LinkedIn → Refresh when LinkedIn changes
```

---

## 11. FAQ

**Why no one-click sync to LinkedIn?**  
No public write API for personal profiles.

**Why is LinkedIn statistics empty?**  
Re-import a data export ZIP that includes analytics CSVs (Profile Views, Search Appearances).

**Where is data stored?**  
Locally (SQLite). API keys in app settings.

**How do I change theme?**  
Settings → Appearance.

---

## Related docs

- [RELEASE.md](RELEASE.md) — builds and releases
- [CONTRIBUTING.md](../CONTRIBUTING.md) — for developers
- [README.md](../README.md) — project overview
