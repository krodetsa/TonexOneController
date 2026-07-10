#!/usr/bin/env bash
# Re-insert the COMPAT STUBS block into the EEZ-generated screens.h.
#
# EEZ Studio regenerates screens.h on every Build and wipes hand-added struct
# fields. display.c / display_tonex.c reference legacy widgets (ui_skin_image,
# ui_chip_*, arrows, ...) that the new mint design doesn't create;
# screens_compat.c fills them with hidden placeholders, but their fields must
# exist in objects_t. Run this after every EEZ Build (before flashing).
set -e
H="$(cd "$(dirname "$0")/.." && pwd)/source/main/ui_generated_800x480land/screens.h"

if grep -q "COMPAT STUBS" "$H"; then
    echo "screens.h already has the COMPAT STUBS block — nothing to do."
    exit 0
fi

read -r -d '' BLOCK <<'EOF' || true
    /* ===== COMPAT STUBS =====
       Widgets used by display.c / display_tonex.c but not produced by the
       current EEZ design. screens_compat_init() creates hidden 0x0
       placeholders for these so runtime code can call LVGL APIs on real
       objects instead of NULL. EEZ regen wipes this — re-run this script. */
    lv_obj_t *ui_skin_image;
    lv_obj_t *ui_preset_details_text_area;
    lv_obj_t *ui_entry_keyboard;
    lv_obj_t *ui_left_arrow;
    lv_obj_t *ui_right_arrow;
    lv_obj_t *ui_ok_tick;
    lv_obj_t *ui_chip_gate;
    lv_obj_t *ui_chip_comp;
    lv_obj_t *ui_chip_eq;
    lv_obj_t *ui_chip_amp;
    lv_obj_t *ui_chip_cab;
    lv_obj_t *ui_chip_mod;
    lv_obj_t *ui_chip_delay;
    lv_obj_t *ui_chip_reverb;
    /* ===== END COMPAT STUBS ===== */
EOF

# insert BLOCK before the "} objects_t;" line
python3 - "$H" "$BLOCK" <<'PY'
import sys
path, block = sys.argv[1], sys.argv[2]
s = open(path).read()
marker = "} objects_t;"
assert marker in s, "objects_t close not found"
s = s.replace(marker, block + "\n" + marker, 1)
open(path, "w").write(s)
print("Inserted COMPAT STUBS block into", path)
PY
