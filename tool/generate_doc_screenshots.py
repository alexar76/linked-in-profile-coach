#!/usr/bin/env python3
"""Generate docs/images compare screenshots (side-by-side + diff) — English UI text."""

from __future__ import annotations

import textwrap
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "docs" / "images"

BG = (17, 24, 39)
SURFACE = (21, 29, 46)
GOLD = (201, 169, 98)
TEXT = (244, 241, 234)
MUTED = (156, 168, 195)
LINKEDIN_BORDER = (100, 110, 130)
RED_BG = (60, 28, 28)
RED_TXT = (255, 200, 200)
GREEN_BG = (24, 50, 36)
GREEN_TXT = (200, 255, 220)

SAMPLES = [
    {
        "key": "headline",
        "title": "Headline",
        "before": "Flutter Developer",
        "after": "Senior Flutter Developer | FinTech & B2B SaaS | Remote · 8+ yrs · Dart, CI/CD",
        "diff": True,
    },
    {
        "key": "about",
        "title": "About",
        "before": "I build mobile apps. Interested in Flutter and product development.",
        "after": (
            "Senior Flutter engineer with 8+ years in FinTech and B2B.\n\n"
            "• Led teams of 6, shipped products to production\n"
            "• Cut time-to-release by 35% with CI/CD\n"
            "• Stack: Flutter, Dart, SQLite, REST\n\n"
            "Open to Tech Lead roles — message me on LinkedIn."
        ),
        "diff": True,
    },
    {
        "key": "experience",
        "title": "Experience",
        "before": "2020–2024 — Mobile Developer, FinApp\nBuilt a Flutter app.",
        "after": (
            "2022–Present — Senior Flutter Developer, FinApp\n"
            "• Client architecture for 60k+ MAU, −40% crashes\n"
            "• Feature flags, golden tests — 2× release cadence\n\n"
            "2019–2022 — Flutter Developer, StartupLab\n"
            "• MVP in 10 weeks → seed round"
        ),
        "diff": False,
    },
    {
        "key": "skills",
        "title": "Skills",
        "before": "Flutter, Dart, Git",
        "after": "Flutter, Dart, SQLite, REST API, CI/CD, Firebase, FinTech, Mobile Architecture, Leadership",
        "diff": False,
    },
]


def wrap_block(text: str, width: int = 42) -> list[str]:
    lines: list[str] = []
    for para in text.split("\n"):
        if not para.strip():
            lines.append("")
            continue
        lines.extend(textwrap.wrap(para, width=width) or [""])
    return lines[:14]


def draw_frame(title: str, subtitle: str | None = None) -> "Image.Image":
    from PIL import Image, ImageDraw, ImageFont

    w, h = 1100, 520
    img = Image.new("RGB", (w, h), BG)
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle((12, 12, w - 13, h - 13), radius=16, fill=SURFACE, outline=GOLD, width=2)
    try:
        font_title = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial Bold.ttf", 22)
        font_sub = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial.ttf", 14)
        font_label = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial Bold.ttf", 15)
        font_body = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial.ttf", 14)
        font_mono = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", 13)
    except OSError:
        font_title = font_sub = font_label = font_body = font_mono = ImageFont.load_default()

    y = 28
    draw.text((32, y), title, fill=TEXT, font=font_title)
    y += 34
    if subtitle:
        draw.text((32, y), subtitle, fill=MUTED, font=font_sub)
        y += 24
    return img, draw, y + 8, font_label, font_body, font_mono


def draw_pane(
    draw,
    x: int,
    y: int,
    pw: int,
    ph: int,
    label: str,
    body: str,
    accent: tuple[int, int, int],
    border: tuple[int, int, int],
    font_label,
    font_body,
):
    draw.rectangle((x, y, x + 4, y + 26), fill=accent)
    draw.text((x + 12, y + 4), label, fill=TEXT, font=font_label)
    py = y + 36
    draw.rounded_rectangle((x, py, x + pw, py + ph), radius=12, fill=(15, 20, 32), outline=border, width=2)
    ty = py + 16
    for line in wrap_block(body, width=46):
        draw.text((x + 16, ty), line, fill=TEXT, font=font_body)
        ty += 20


def side_by_side(sample: dict) -> None:
    from PIL import Image

    img, draw, content_y, font_label, font_body, font_mono = draw_frame(
        sample["title"],
        "Left — LinkedIn (import), right — AI version",
    )
    pw = (img.width - 84) // 2
    ph = img.height - content_y - 32
    draw_pane(
        draw, 32, content_y, pw, ph,
        "LinkedIn (import)", sample["before"], MUTED, LINKEDIN_BORDER,
        font_label, font_body,
    )
    draw_pane(
        draw, 52 + pw, content_y, pw, ph,
        "AI version", sample["after"], GOLD, GOLD,
        font_label, font_body,
    )
    path = OUT / f"{sample['key']}-side.png"
    img.save(path)
    print(f"Wrote {path}")


def simple_diff_lines(before: str, after: str) -> list[tuple[str, str]]:
    b = [ln.strip() for ln in before.split("\n") if ln.strip()]
    a = [ln.strip() for ln in after.split("\n") if ln.strip()]
    lines: list[tuple[str, str]] = []
    for ln in b:
        if ln not in a:
            lines.append(("removed", ln))
    for ln in a:
        if ln not in b:
            lines.append(("added", ln))
    for ln in b:
        if ln in a:
            lines.append(("same", ln))
    return lines[:16]


def diff_view(sample: dict) -> None:
    from PIL import Image, ImageDraw, ImageFont

    img, draw, content_y, font_label, font_body, font_mono = draw_frame(
        f"{sample['title']} — Diff",
        "Red (−) removed · Green (+) added",
    )
    try:
        font_mono = ImageFont.truetype("/System/Library/Fonts/Menlo.ttc", 13)
    except OSError:
        font_mono = ImageFont.load_default()

    x, w = 32, img.width - 64
    y = content_y
    draw.rounded_rectangle((x, y, x + w, img.height - 32), radius=12, fill=(15, 20, 32), outline=LINKEDIN_BORDER, width=2)

    ty = y + 14
    for kind, text in simple_diff_lines(sample["before"], sample["after"]):
        if kind == "removed":
            bg, fg, prefix = RED_BG, RED_TXT, "− "
        elif kind == "added":
            bg, fg, prefix = GREEN_BG, GREEN_TXT, "+ "
        else:
            bg, fg, prefix = (15, 20, 32), MUTED, "  "
        line = textwrap.shorten(prefix + text, width=95, placeholder="…")
        draw.rectangle((x + 10, ty, x + w - 10, ty + 22), fill=bg)
        draw.text((x + 16, ty + 3), line, fill=fg, font=font_mono)
        ty += 24
        if ty > img.height - 48:
            break

    path = OUT / f"{sample['key']}-diff.png"
    img.save(path)
    print(f"Wrote {path}")


def overview() -> None:
    sample = SAMPLES[0]
    from PIL import Image, ImageDraw, ImageFont

    img, draw, content_y, font_label, font_body, _ = draw_frame(
        "Compare — overview",
        "Compare tab: side by side, diff, similarity %, publish to LinkedIn",
    )
    try:
        font_badge = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial Bold.ttf", 16)
    except OSError:
        font_badge = ImageFont.load_default()

    cx = img.width - 90
    cy = 36
    draw.ellipse((cx - 32, cy - 8, cx + 32, cy + 56), outline=GOLD, width=4)
    draw.text((cx - 22, cy + 16), "42%", fill=GOLD, font=font_badge)

    pw = (img.width - 84) // 2
    ph = 360
    draw_pane(draw, 32, 100, pw, ph, "LinkedIn (import)", sample["before"], MUTED, LINKEDIN_BORDER, font_label, font_body)
    draw_pane(draw, 52 + pw, 100, pw, ph, "AI version", sample["after"], GOLD, GOLD, font_label, font_body)

    path = OUT / "overview.png"
    img.save(path)
    print(f"Wrote {path}")


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    # Remove legacy Russian-era filenames
    for old in OUT.glob("compare-*.png"):
        old.unlink()
        print(f"Removed {old}")
    overview()
    for s in SAMPLES:
        side_by_side(s)
        if s.get("diff"):
            diff_view(s)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
