---
name: project_overview
description: VoiceToText v2 — GTK4/Libadwaita floating overlay voice dictation app for Linux/Wayland
type: project
---

GTK4/Libadwaita Python app using faster-whisper for local voice-to-text on Linux/Wayland (Arch + Hyprland).

**Architecture:**
- `voicetotext/app.py` — Adw.Application wiring state machine, UI, recorder, transcriber, hotkey
- `voicetotext/core/` — config.py, state.py (thread-safe FSM), recorder.py (sounddevice), transcriber.py (faster-whisper), postprocessor.py (regex Unicode filler removal)
- `voicetotext/services/` — hotkey.py (HTTP server 127.0.0.1:9876 + EvdevHotkey fallback), output.py (wtype paste, wl-copy fallback, notify-send)
- `voicetotext/ui/` — overlay.py (gtk4-layer-shell floating pill, draggable), settings_popover.py (model/language/mode/notifications)

**Key details:**
- CUDA 12 + float16 by default, CPU int8 fallback
- HTTP endpoints: POST /start, /stop, /toggle (idempotent)
- Hyprland bind/bindr for push-to-talk, bind for toggle
- State machine: Idle→Recording→Processing→Result→Idle
- VAD: off for push-to-talk, on for toggle mode
- Config at ~/.config/voicetotext/config.json
- Tests: 64 tests (pytest), 86% coverage on non-UI code
- Python 3.14, no history/tabs (minimalist overlay)
- Overlay: keyboard_interactivity=NONE, never steals focus

**How to apply:** Run via `./run.sh`. Tests: `.venv/bin/python -m pytest tests/ -v`.
