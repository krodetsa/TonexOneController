/* No-op stubs for every action_* declared in actions.h (real ones live in
   display*.c on the firmware and don't build on PC). */
#include "lvgl.h"
#include "actions.h"

void action_next_clicked(lv_event_t *e) { (void)e; }
void action_previous_clicked(lv_event_t *e) { (void)e; }
void action_amp_skin_next(lv_event_t *e) { (void)e; }
void action_amp_skin_previous(lv_event_t *e) { (void)e; }
void action_parameter_changed(lv_event_t *e) { (void)e; }
void action_close_settings_page(lv_event_t *e) { (void)e; }
void action_show_settings_page(lv_event_t *e) { (void)e; }
void action_enable_skin_edit(lv_event_t *e) { (void)e; }
void action_save_skin_edit(lv_event_t *e) { (void)e; }
void action_keyboard_ok(lv_event_t *e) { (void)e; }
void action_preset_description_pressed(lv_event_t *e) { (void)e; }
void action_effect_icon_clicked(lv_event_t *e) { (void)e; }
void action_gesture(lv_event_t *e) { (void)e; }
void action_value_clicked(lv_event_t *e) { (void)e; }
void action_value_keyboard_ok(lv_event_t *e) { (void)e; }
