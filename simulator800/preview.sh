#!/usr/bin/env bash
# Render the current UI to preview.png (rebuilds first).
#   ./preview.sh                 # -> simulator800/preview.png
set -e
SIM="$(cd "$(dirname "$0")" && pwd)"
[ -x "$SIM/tonex_sim" ] || bash "$SIM/build.sh"
"$SIM/tonex_sim" "$SIM/preview.ppm"
if command -v python3 >/dev/null && python3 -c "import PIL" 2>/dev/null; then
    python3 -c "from PIL import Image; Image.open('$SIM/preview.ppm').save('$SIM/preview.png')"
    echo "Wrote $SIM/preview.png"
elif command -v convert >/dev/null; then
    convert "$SIM/preview.ppm" "$SIM/preview.png"; echo "Wrote $SIM/preview.png"
else
    echo "Wrote $SIM/preview.ppm (install python3-pil or imagemagick to get PNG)"
fi
