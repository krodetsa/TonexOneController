/*
 * Headless LVGL renderer for the 800x480 UI.
 * No SDL / no window: draws the screen into a framebuffer and dumps a PPM,
 * so we can render the design to an image on any machine (just gcc + LVGL).
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include "lvgl.h"
#include "ui.h"

#define HOR 800
#define VER 480

static lv_color_t fb[HOR * VER];
static lv_color_t drawbuf[HOR * 60];
static lv_disp_draw_buf_t ddb;
static lv_disp_drv_t drv;

static void flush_cb(lv_disp_drv_t *d, const lv_area_t *a, lv_color_t *px)
{
    for (int y = a->y1; y <= a->y2; y++) {
        for (int x = a->x1; x <= a->x2; x++) {
            fb[y * HOR + x] = *px++;
        }
    }
    lv_disp_flush_ready(d);
}

int main(int argc, char **argv)
{
    const char *out = (argc > 1) ? argv[1] : "out.ppm";

    lv_init();
    lv_disp_draw_buf_init(&ddb, drawbuf, NULL, HOR * 60);
    lv_disp_drv_init(&drv);
    drv.hor_res  = HOR;
    drv.ver_res  = VER;
    drv.flush_cb = flush_cb;
    drv.draw_buf = &ddb;
    lv_disp_drv_register(&drv);

    ui_init();

    /* let the 200ms fade-in + layout settle */
    for (int i = 0; i < 40; i++) {
        lv_tick_inc(16);
        lv_timer_handler();
    }

    FILE *f = fopen(out, "wb");
    if (!f) { perror("fopen"); return 1; }
    fprintf(f, "P6\n%d %d\n255\n", HOR, VER);
    for (int i = 0; i < HOR * VER; i++) {
        lv_color32_t c;
        c.full = lv_color_to32(fb[i]);
        unsigned char rgb[3] = { c.ch.red, c.ch.green, c.ch.blue };
        fwrite(rgb, 1, 3, f);
    }
    fclose(f);
    printf("wrote %s (%dx%d)\n", out, HOR, VER);
    return 0;
}
