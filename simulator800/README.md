# 800×480 headless UI simulator (Waveshare 4.3B)

Renders `source/main/ui_generated_800x480land/screens.c` to an image on your PC,
so you can iterate on the 4.3B UI without flashing hardware. The **same
`screens.c`** compiles here and into the firmware.

Unlike the upstream `simulator/` (which needs SDL2 + a window), this one is
**headless**: it draws one frame into a buffer and dumps a PNG. It needs only
`gcc` + `make`-era tools and the LVGL copy already vendored in
`source/components/lvgl__lvgl` — no cmake, no SDL, no network.

## Use

```bash
cd simulator800
./preview.sh          # builds if needed, renders -> preview.png
```

Iterate:

```bash
# edit ../source/main/ui_generated_800x480land/screens.c
./build.sh            # ~seconds after the first full build
./preview.sh          # refresh preview.png
```

First build compiles ~320 files (LVGL + all `ui_image_*.c`); later rebuilds only
recompile what changed.

## Notes

- Renders at `LV_COLOR_DEPTH 32` for true-colour PNGs. The device uses 16-bit
  BGR (`LV_COLOR_16_SWAP`); hues match, exact shades can differ slightly.
- `action_*` handlers are no-op stubs (`stub_actions.c`) — real ones live in
  `display*.c` and depend on USB/FreeRTOS. So this previews **layout & style**,
  with placeholder text ("Preset Name", BPM 0), not live pedal data.
- `lv_conf.h` mirrors the firmware's LVGL config plus the fonts this UI uses.
  If `screens.c` starts using a new `lv_font_montserrat_N`, enable it here too.
- **This folder is the edit target for the 4.3B redesign.** Don't regenerate
  `ui_generated_800x480land/` from EEZ Studio or hand-edits get overwritten.

## Want an interactive window instead?

Install `cmake` + `libsdl2-dev`, then adapt the upstream `simulator/` (SDL) to
point `UI_DIR` at `ui_generated_800x480land` and set `480/320 -> 800/480`.
