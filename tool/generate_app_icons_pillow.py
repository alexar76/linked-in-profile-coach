#!/usr/bin/env python3
"""Generate app icons for macOS, Windows, and Android — Profile Coach monogram."""

from __future__ import annotations

import math
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BRANDING = ROOT / "assets" / "branding"
MACOS_OUT = ROOT / "macos" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
WINDOWS_ICO = ROOT / "windows" / "runner" / "resources" / "app_icon.ico"
ANDROID_RES = ROOT / "android" / "app" / "src" / "main" / "res"

BG_TOP = (12, 18, 36)
BG_MID = (20, 30, 52)
BG_BOT = (8, 14, 24)
GOLD_HI = (240, 226, 184)
GOLD = (212, 183, 106)
GOLD_LO = (154, 123, 60)
BLUE_GLOW = (10, 102, 194)

MACOS_SIZES = {
    "app_icon_16.png": 16,
    "app_icon_32.png": 32,
    "app_icon_64.png": 64,
    "app_icon_128.png": 128,
    "app_icon_256.png": 256,
    "app_icon_512.png": 512,
    "app_icon_1024.png": 1024,
}

ANDROID_SIZES = {
    "mipmap-mdpi/ic_launcher.png": 48,
    "mipmap-hdpi/ic_launcher.png": 72,
    "mipmap-xhdpi/ic_launcher.png": 96,
    "mipmap-xxhdpi/ic_launcher.png": 144,
    "mipmap-xxxhdpi/ic_launcher.png": 192,
}

WINDOWS_ICO_SIZES = [16, 24, 32, 48, 64, 128, 256]


def lerp(a: int, b: int, t: float) -> int:
    return int(a + (b - a) * t)


def lerp_color(c1: tuple[int, int, int], c2: tuple[int, int, int], t: float) -> tuple[int, int, int]:
    return (lerp(c1[0], c2[0], t), lerp(c1[1], c2[1], t), lerp(c1[2], c2[2], t))


def gradient_bg(size: int, Image, ImageDraw):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    px = img.load()
    for y in range(size):
        t = y / max(size - 1, 1)
        if t < 0.5:
            c = lerp_color(BG_TOP, BG_MID, t / 0.5)
        else:
            c = lerp_color(BG_MID, BG_BOT, (t - 0.5) / 0.5)
        for x in range(size):
            px[x, y] = (*c, 255)
    return img


def rounded_mask(size: int, radius: float, Image, ImageDraw):
    m = Image.new("L", (size, size), 0)
    d = ImageDraw.Draw(m)
    d.rounded_rectangle((0, 0, size - 1, size - 1), radius=radius, fill=255)
    return m


def draw_arc_ring(draw, cx: int, cy: int, r: int, width: int, start: float, end: float, color):
    draw.arc(
        (cx - r, cy - r, cx + r, cy + r),
        start=start,
        end=end,
        fill=color,
        width=width,
    )


def draw_star(draw, cx: int, cy: int, outer: int, color):
    points = []
    for i in range(8):
        ang = -math.pi / 2 + i * math.pi / 4
        rad = outer if i % 2 == 0 else outer * 0.42
        points.append((cx + rad * math.cos(ang), cy + rad * math.sin(ang)))
    draw.polygon(points, fill=color)


def draw_monogram_p(draw, size: int, gold: tuple[int, int, int]):
    """Bold solid P — no silhouette, readable from 16px."""
    s = size / 512.0
    x0, y0 = int(184 * s), int(152 * s)
    x1 = int(224 * s)
    y1 = int(360 * s)
    bx1 = int(312 * s)
    by_bowl = int(296 * s)

    draw.rounded_rectangle(
        (x0, y0, x1, y1),
        radius=max(2, int(10 * s)),
        fill=gold,
    )
    draw.rounded_rectangle(
        (x1 - max(1, int(6 * s)), y0, bx1, by_bowl),
        radius=max(3, int(32 * s)),
        fill=gold,
    )


def draw_icon(size: int, Image, ImageDraw):
    s = size / 512.0
    img = gradient_bg(size, Image, ImageDraw)
    draw = ImageDraw.Draw(img)

    tile_r = int(108 * s)
    pad = int(24 * s)
    draw.rounded_rectangle(
        (pad, pad, size - pad - 1, size - pad - 1),
        radius=int(92 * s),
        outline=GOLD_LO + (45,),
        width=max(1, int(2 * s)),
    )

    cx, cy = size // 2, int(268 * s)

    # Center glow
    glow_r = int(148 * s)
    if glow_r > 2:
        glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        gd = ImageDraw.Draw(glow)
        gd.ellipse(
            (cx - glow_r, cy - glow_r, cx + glow_r, cy + glow_r),
            fill=GOLD + (35,),
        )
        img = Image.alpha_composite(img.convert("RGBA"), glow)

    draw = ImageDraw.Draw(img)

    ring_r = int(148 * s)
    ring_w = max(2, int(20 * s))
    if ring_r > ring_w:
        draw_arc_ring(draw, cx, int(216 * s), ring_r, ring_w, 200, 340, GOLD)
        if size >= 48:
            draw_arc_ring(
                draw, cx, int(216 * s), int(128 * s), max(1, int(8 * s)), 256, 310, GOLD_HI + (90,)
            )

    # Gold gradient simulation: use hi gold for main mark
    draw_monogram_p(draw, size, GOLD_HI if size >= 64 else GOLD)

    if size >= 32:
        star_x, star_y = int(342 * s), int(168 * s)
        star_r = max(3, int(24 * s))
        draw_star(draw, star_x, star_y, star_r, GOLD_HI)

    mask = rounded_mask(size, tile_r, Image, ImageDraw)
    img.putalpha(mask)
    return img


def main() -> int:
    try:
        from PIL import Image, ImageDraw
    except ImportError:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "pillow", "-q"])
        from PIL import Image, ImageDraw

    BRANDING.mkdir(parents=True, exist_ok=True)
    MACOS_OUT.mkdir(parents=True, exist_ok=True)
    WINDOWS_ICO.parent.mkdir(parents=True, exist_ok=True)

    master = draw_icon(1024, Image, ImageDraw)
    master_path = BRANDING / "app_icon_1024.png"
    master.save(master_path, "PNG")
    print(f"Wrote {master_path}")

    for name, px in MACOS_SIZES.items():
        path = MACOS_OUT / name
        draw_icon(px, Image, ImageDraw).save(path, "PNG")
        print(f"Wrote {path} ({px}px)")

    ico_images = [draw_icon(s, Image, ImageDraw) for s in WINDOWS_ICO_SIZES]
    ico_images[0].save(
        WINDOWS_ICO,
        format="ICO",
        sizes=[(im.width, im.height) for im in ico_images],
        append_images=ico_images[1:],
    )
    print(f"Wrote {WINDOWS_ICO}")

    for rel, px in ANDROID_SIZES.items():
        path = ANDROID_RES / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        draw_icon(px, Image, ImageDraw).save(path, "PNG")
        print(f"Wrote {path} ({px}px)")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
