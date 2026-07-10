#!/usr/bin/env bash
# Headless LVGL renderer for the 800x480 UI (Waveshare 4.3B).
# Builds the firmware's ui_generated_800x480land/ into a tiny PC executable
# that renders one frame to a PPM image — no SDL, no cmake, no network needed.
#   ./build.sh        # compile + link -> ./tonex_sim
set -e
SIM="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SIM/.." && pwd)"
LVGL="$ROOT/source/components/lvgl__lvgl"
UI="$ROOT/source/main/ui_generated_800x480land"
OBJ="$SIM/obj"
mkdir -p "$OBJ"

export CFLAGS="-I$LVGL -I$ROOT/source/components -I$UI -I$SIM -DLV_CONF_INCLUDE_SIMPLE -O1 -w"

: > "$SIM/srcs.txt"
find "$LVGL/src" -name '*.c' >> "$SIM/srcs.txt"
for f in screens.c ui.c images.c styles.c; do echo "$UI/$f" >> "$SIM/srcs.txt"; done
[ -f "$UI/vars.c" ] && echo "$UI/vars.c" >> "$SIM/srcs.txt" || true
ls "$UI"/ui_image_*.c >> "$SIM/srcs.txt"
ls "$UI"/ui_font_*.c 2>/dev/null >> "$SIM/srcs.txt" || true
echo "$SIM/main_headless.c" >> "$SIM/srcs.txt"
echo "$SIM/stub_actions.c" >> "$SIM/srcs.txt"

echo "Compiling $(wc -l < "$SIM/srcs.txt") files in parallel..."
export OBJ
cat "$SIM/srcs.txt" | xargs -P"$(nproc)" -I{} bash -c '
  src="{}"; o="$OBJ/$(echo "$src" | md5sum | cut -c1-16).o"
  gcc $CFLAGS -c "$src" -o "$o"
'
echo "Linking..."
gcc "$OBJ"/*.o -lm -o "$SIM/tonex_sim"
echo "Built: $SIM/tonex_sim"
