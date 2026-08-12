-- Hyprland default apps

TERMINAL     = "kitty"
FILE_MANAGER = "dolphin"
BROWSER      = "firefox"
EDITOR       = "kitty -e nvim"
CALCULATOR   = "gnome-calculator"

-- Monitors (machine-specific — list outputs with `hyprctl monitors`).
-- Workspaces are pinned to these in order (see workspaces.lua). Leave "" if absent.
MONITOR1 = "eDP-1"    -- laptop panel (primary)
-- Matched by description, not connector name: the USB-C port lands this panel on
-- the Intel iGPU as DP-1, the dGPU-wired DP port as DP-3. Description survives both.
MONITOR2 = "desc:Lenovo Group Limited LEN P27u-10 0x52364D54" -- external (office), sits physically left of the laptop
MONITOR3 = "desc:AOC Q3279WG5B 0x00000D75"                     -- external (home)
PRIMARY_MONITOR = MONITOR1

-- Workspaces: which workspace numbers live on which monitor.
-- The first workspace listed for a monitor becomes that monitor's default.
-- MONITOR2 and MONITOR3 are the two external panels used in different places; they
-- share the same workspace range because only one is ever plugged in at a time.
-- Rules for an absent monitor are simply skipped (see workspaces.lua).
WS_LAYOUT = {
    { monitor = MONITOR1, workspaces = { 1, 2 } },
    { monitor = MONITOR2, workspaces = { 3, 4, 5, 6, 7 } },
    { monitor = MONITOR3, workspaces = { 3, 4, 5, 6, 7 } },
}

NUM_MONITORS = 0
for _, m in ipairs({ MONITOR1, MONITOR2, MONITOR3 }) do
    if m ~= "" then NUM_MONITORS = NUM_MONITORS + 1 end
end

-- Derived: highest workspace number, used by binds.lua to build the SUPER+N binds.
-- SUPER+N focuses workspace N wherever it lives, so pressing a number in another
-- monitor's range jumps focus to that monitor.
NUM_WS = 0
for _, entry in ipairs(WS_LAYOUT) do
    for _, w in ipairs(entry.workspaces) do
        if w > NUM_WS then NUM_WS = w end
    end
end
