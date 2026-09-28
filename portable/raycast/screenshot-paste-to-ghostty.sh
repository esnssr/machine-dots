#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Screenshot and Paste to Ghostty
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📸
# @raycast.packageName Utilities
# @raycast.description Take an interactive screenshot, copy it to the clipboard, and paste it into Ghostty with Control+V.

# Eslam Nasser assisted by Claude

# Take an interactive screenshot and copy it directly to the clipboard.
# -i = interactive selection/window capture
# -c = copy to clipboard instead of saving a file
screencapture -i -c

# If the user cancels the screenshot, screencapture exits non-zero.
# Exit safely without activating or pasting into Ghostty.
if [ $? -ne 0 ]; then
  exit 0
fi

# Send Control+V straight to the focused Ghostty terminal via Ghostty's scripting API.
# Uses the raw Control+V byte (\x16): "send key" produces nothing when the CLI has the
# kitty keyboard protocol enabled (as Claude Code does).
osascript -l JavaScript <<'JXA'
const ghostty = Application("Ghostty");
ghostty.activate();
const terminal = ghostty.frontWindow.selectedTab.focusedTerminal;
ghostty.performAction("text:\\x16", { on: terminal });
JXA
