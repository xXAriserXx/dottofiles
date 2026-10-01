#!/usr/bin/osascript -l JavaScript
// Stretch the front window of an app to the full width of the screen it is on
// (keeps its height and vertical position). Used by aerospace.toml for floating windows.
// Usage: aerospace-fullwidth.js <process name>   e.g. aerospace-fullwidth.js Preview
ObjC.import('AppKit');

function run(argv) {
  const se = Application('System Events');
  const proc = se.processes.byName(argv[0]);
  let win;
  for (let i = 0; i < 20; i++) {          // window may not be ready yet
    try { win = proc.windows[0]; win.position(); break; } catch (e) { delay(0.1); win = null; }
  }
  if (!win) return;

  const [x, y] = win.position();
  const [, h] = win.size();
  // NSScreen uses bottom-left origin; System Events uses top-left of the primary screen.
  const screens = $.NSScreen.screens.js;
  const primaryH = screens[0].frame.size.height;
  const screen = screens.find(s => {
    const f = s.frame;
    const top = primaryH - (f.origin.y + f.size.height);
    return x >= f.origin.x && x < f.origin.x + f.size.width && y >= top && y < top + f.size.height;
  }) || screens[0];

  const vf = screen.visibleFrame;          // excludes menu bar and Dock
  const visTop = primaryH - (vf.origin.y + vf.size.height);
  const height = Math.min(h, vf.size.height);
  win.position = [vf.origin.x, Math.max(y, visTop)];
  win.size = [vf.size.width, height];
}
