-- Hyprland default apps

TERMINAL     = "kitty"
FILE_MANAGER = "dolphin"
BROWSER      = "firefox"
EDITOR       = "kitty -e nvim"
CALCULATOR   = "gnome-calculator"

-- Monitors (machine-specific — list outputs with `hyprctl monitors`).
-- Workspaces are pinned to these in order (see workspaces.lua). Leave "" if absent.
MONITOR1 = "eDP-1"    -- laptop panel (primary)
MONITOR2 = "HDMI-A-1" -- external
MONITOR3 = ""
PRIMARY_MONITOR = MONITOR1

-- Workspaces
NUM_WPM = 3 -- Number of workspaces per monitor (Max 10)

-- Derived: NUM_WPM workspaces per connected monitor, numbered consecutively
-- (NUM_WPM=3 → MONITOR1: 1-3, MONITOR2: 4-6). SUPER+N focuses workspace N wherever
-- it lives, so pressing a number on another monitor's range jumps focus there.
NUM_MONITORS = 0
for _, m in ipairs({ MONITOR1, MONITOR2, MONITOR3 }) do
    if m ~= "" then NUM_MONITORS = NUM_MONITORS + 1 end
end
local _mc = NUM_MONITORS
if _mc < 1 then _mc = 1 end
NUM_WS = NUM_WPM * _mc
