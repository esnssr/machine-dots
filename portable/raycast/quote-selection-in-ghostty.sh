#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Quote Selection in Ghostty
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 💬
# @raycast.packageName Utilities
# @raycast.description Quote the selected text in Ghostty (each line prefixed with "> ") into the prompt on its own line, with the cursor on a new line below.

# Eslam Nasser assisted by Claude

# Uses Ghostty's scripting API directly: no synthetic keystrokes, no timing races.
osascript -l JavaScript <<'JXA'
ObjC.import("AppKit");

const ghostty = Application("Ghostty");
const terminal = ghostty.frontWindow.selectedTab.focusedTerminal;
const pasteboard = $.NSPasteboard.generalPasteboard;

function readClipboard() {
  const s = pasteboard.stringForType($.NSPasteboardTypeString);
  return s.isNil() ? "" : s.js;
}

// Splits a line of Ghostty's VT screen dump into all printed text and the text
// that isn't faint. Claude Code and Codex draw placeholders and suggestions faint,
// so those don't count as typed text.
function parseVtLine(line) {
  let all = "", content = "", faint = false;
  for (let i = 0; i < line.length; i++) {
    if (line[i] === "\x1b" && line[i + 1] === "[") {
      let j = i + 2;
      while (j < line.length && !/[@-~]/.test(line[j])) j++;
      if (line[j] === "m") {
        const params = line.slice(i + 2, j).split(";");
        for (let k = 0; k < params.length; k++) {
          const p = params[k];
          if (p === "" || p === "0" || p === "22") faint = false;
          else if (p === "2") faint = true;
          // Skip extended color arguments so the "2" in 38;2;r;g;b isn't read as faint.
          else if (p === "38" || p === "48" || p === "58") k += params[k + 1] === "5" ? 2 : 4;
        }
      }
      i = j;
    } else if (line[i] === "\x1b" && line[i + 1] === "]") {
      // OSC (e.g. hyperlinks) ends at BEL or ESC \.
      let j = i + 2;
      while (j < line.length && line[j] !== "\x07" && !(line[j] === "\x1b" && line[j + 1] === "\\")) j++;
      i = line[j] === "\x07" ? j : j + 1;
    } else if (line[i] !== "\r") {
      all += line[i];
      if (!faint) content += line[i];
    }
  }
  return { all: all.trimEnd(), content: content.trim() };
}

// Whether the prompt's last input line already has text, read from a dump of the
// visible screen. Assumes the cursor is at the end of the input. Returns false
// when no prompt is found, so the quote is inserted as before.
function promptLineHasText(selection) {
  ghostty.performAction("write_screen_file:copy,vt", { on: terminal });
  const path = readClipboard();
  // The action replaced the clipboard with the dump's path; put the selection back.
  pasteboard.clearContents;
  pasteboard.setStringForType($(selection), $.NSPasteboardTypeString);
  if (!path.startsWith("/")) return false;

  const screen = $.NSString.stringWithContentsOfFileEncodingError(path, $.NSUTF8StringEncoding, null);
  $.NSFileManager.defaultManager.removeItemAtPathError(path, null);
  if (screen.isNil()) return false;

  const lines = screen.js.split("\n").map(parseVtLine);
  const isPrompt = l => /^[❯›](\s|$)/.test(l.all);
  const isRule = l => /^─{3,}/.test(l.all.trim());

  let start = -1;
  for (let i = lines.length - 1; i >= 0 && start < 0; i--) if (isPrompt(lines[i])) start = i;
  if (start < 0) return false;

  // Claude Code closes the input box with a rule, and the input can contain blank
  // lines. Codex has no rule, so its input ends at the first blank line.
  let end = start;
  const ruleBelow = lines.findIndex((l, i) => i > start && isRule(l));
  if (ruleBelow > 0) end = ruleBelow - 1;
  else while (end + 1 < lines.length && lines[end + 1].all.trim()) end++;

  return lines[end].content.replace(/^[❯›]/, "").trim() !== "";
}

// Copy Ghostty's own selection, if there is one. When the CLI owns the selection
// (Claude Code / Codex mouse mode) this returns false and copy-on-select has
// already put the text on the clipboard.
ghostty.performAction("copy_to_clipboard", { on: terminal });
const selection = readClipboard();

if (selection) {
  // Strip trailing whitespace per line (terminal selections pad lines with spaces),
  // prefix each line with "> ", and end with a newline so the cursor lands below the quote.
  // Start on a new line when the cursor's line already has text.
  const quote = selection.replace(/\n+$/, "").split("\n")
    .map(line => "> " + line.replace(/\s+$/, "")).join("\n") + "\n";
  ghostty.inputText((promptLineHasText(selection) ? "\n" : "") + quote, { to: terminal });
}
JXA
