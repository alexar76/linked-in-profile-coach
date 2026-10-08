#!/usr/bin/env python3
"""Generate macOS AppIcon PNGs. Delegates to Pillow renderer (no cairo required)."""

import subprocess
import sys
from pathlib import Path

if __name__ == "__main__":
    script = Path(__file__).with_name("generate_app_icons_pillow.py")
    raise SystemExit(subprocess.call([sys.executable, str(script)]))
