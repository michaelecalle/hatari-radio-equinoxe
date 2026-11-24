/*
  Hatari - gui_event.h

  SPDX-License-Identifier: GPL-2.0-or-later
*/

#ifndef HATARI_GUI_EVENT_H
#define HATARI_GUI_EVENT_H

void GuiEvent_WarpMouse(int x, int y, bool restore);
void GuiEvent_EventHandler(void);
#ifdef EMSCRIPTEN
void GuiEvent_TouchMouseMove(int dx, int dy);
void GuiEvent_TouchMouseButton(int right, int down);
#endif

#endif
