-- Hyprland default apps

TERMINAL     = "kitty"
FILE_MANAGER = "dolphin"
BROWSER      = "com.google.Chrome" -- Flatpak launcher, exported on PATH
EDITOR       = "kitty -e nvim"
CALCULATOR   = "gnome-calculator"

-- Monitors (machine-specific — list outputs with `hyprctl monitors`).
-- Workspaces are pinned to these in order (see workspaces.lua). Leave "" if absent.
MONITOR1 = "eDP-1"    -- laptop panel (primary)
-- Matched by description, not connector name: the USB-C port lands this panel on
-- the Intel iGPU as DP-1, the dGPU-wired DP port as DP-3. Description survives both.
MONITOR2 = "desc:Lenovo Group Limited LEN P27u-10 0x52364D54" -- external (office), sits physically right of the laptop
MONITOR3 = "desc:AOC Q3279WG5B 0x00000D75"                     -- external (home)
PRIMARY_MONITOR = MONITOR1

-- Workspaces. The laptop always owns 1..LAPTOP_WS; every external that is actually
-- connected claims the next free block of EXTERNAL_WS workspaces, in EXTERNALS order.
-- Numbering therefore slides instead of being pinned per panel, and two externals can
-- never be handed the same numbers (a duplicate workspace rule silently loses to the
-- last one declared, which strands the workspaces on a monitor that is not plugged in).
LAPTOP_WS   = 3
EXTERNAL_WS = 5

-- `edid` is a substring to look for in a connector's EDID blob, used to decide whether
-- that external is plugged in right now. Keep it to the model name: the make and serial
-- are not always present as plain text.
-- `mode` and `scale` are optional; they default to "preferred"/"auto" in monitors.lua.
-- Do not force 3840x2160@60 on the P27u-10 here: the mode applies and reports as active,
-- but the panel goes dark, so something downstream of the modeset cannot carry it.
EXTERNALS = {
    { monitor = MONITOR2, edid = "LEN P27u-10" },
    { monitor = MONITOR3, edid = "Q3279WG5B" },
}

-- Connected panels are read straight from DRM sysfs, not from hyprctl: the config is
-- parsed before the compositor's IPC socket exists, so on a cold boot hyprctl has
-- nothing to answer with. `grep -lx` avoids matching the word "disconnected".
local function connected_edids()
    local blobs = {}
    local list = io.popen("grep -lx connected /sys/class/drm/card*-*/status 2>/dev/null")
    if not list then return blobs end
    for status_path in list:lines() do
        local f = io.open((status_path:gsub("/status$", "/edid")), "rb")
        if f then
            blobs[#blobs + 1] = f:read("a") or ""
            f:close()
        end
    end
    list:close()
    return blobs
end

local function is_plugged(blobs, mark)
    for _, blob in ipairs(blobs) do
        if blob:find(mark, 1, true) then return true end
    end
    return false
end

local function block(first, count)
    local ws = {}
    for i = 1, count do ws[i] = first + i - 1 end
    return ws
end

-- Derived: consumed by workspaces.lua (one rule per workspace) and by NUM_WS below.
-- The first workspace listed for a monitor becomes that monitor's default.
WS_LAYOUT = { { monitor = MONITOR1, workspaces = block(1, LAPTOP_WS) } }

local blobs = connected_edids()
local next_ws = LAPTOP_WS + 1
for _, ext in ipairs(EXTERNALS) do
    if ext.monitor ~= "" and is_plugged(blobs, ext.edid) then
        WS_LAYOUT[#WS_LAYOUT + 1] = {
            monitor    = ext.monitor,
            workspaces = block(next_ws, EXTERNAL_WS),
        }
        next_ws = next_ws + EXTERNAL_WS
    end
end

NUM_MONITORS = #WS_LAYOUT

-- Derived: highest workspace number, used by binds.lua to build the SUPER+N binds.
-- SUPER+N focuses workspace N wherever it lives, so pressing a number in another
-- monitor's range jumps focus to that monitor. Unplugged externals contribute no
-- workspaces, so no bind points at a workspace that has nowhere to live.
NUM_WS = 0
for _, entry in ipairs(WS_LAYOUT) do
    for _, w in ipairs(entry.workspaces) do
        if w > NUM_WS then NUM_WS = w end
    end
end
