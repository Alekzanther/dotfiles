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
MONITOR4 = "desc:AOC Q32V4WG5 QHPP2HA000413"                   -- external (AOC Q32V4, HDMI)
MONITOR5 = "desc:Samsung Electric Company U32J59x H4LR800448"   -- external (Samsung U32J59x 4K, HDMI)
PRIMARY_MONITOR = MONITOR1

-- Render on the NVIDIA dGPU instead of the iGPU when, at login, an external is plugged
-- into a port wired to the dGPU (HDMI, DP-3). See environment.lua. Set false to always
-- render on the iGPU.
DGPU_RENDER_WHEN_DOCKED = true

-- Workspaces. The laptop always owns 1..LAPTOP_WS; every external that is actually
-- connected claims the next free block of EXTERNAL_WS workspaces, in connector order.
-- Numbering therefore slides instead of being pinned per panel, and two externals can
-- never be handed the same numbers (a duplicate workspace rule silently loses to the
-- last one declared, which strands the workspaces on a monitor that is not plugged in).
LAPTOP_WS   = 3
EXTERNAL_WS = 5

-- `edid` is a substring to look for in a connector's EDID blob, used to decide whether
-- that external is plugged in right now. Keep it to the model name: the make and serial
-- are not always present as plain text.
-- `mode` and `scale` are optional; they default to "preferred"/"auto" in monitors.lua.
-- `left_width` puts that panel LEFT of the laptop instead of right; it is the panel's
-- logical width (pixels / scale), which the laptop is shifted right by.
-- Do not force 3840x2160@60 on the P27u-10 here: the mode applies and reports as active,
-- but the panel goes dark, so something downstream of the modeset cannot carry it.
-- The Q32V4 prefers 60 Hz but its EDID also lists 2560x1440@75.
-- The U32J59x does 4K60 over HDMI only with an HDMI 2.0-capable cable/input: otherwise its
-- EDID caps TMDS at 300 MHz and the best it lists is 4K30, which feels laggy. If it ever
-- drops back to 4K30, use mode = "2560x1440@60", scale = 1, left_width = 2560.
-- A connected panel that matches none of these still gets a workspace block, pinned by
-- its connector name, so an unknown screen never caps the workspace numbering.
EXTERNALS = {
    { monitor = MONITOR2, edid = "LEN P27u-10" },
    { monitor = MONITOR3, edid = "Q3279WG5B" },
    { monitor = MONITOR4, edid = "Q32V4WG5", mode = "2560x1440@75" },
    { monitor = MONITOR5, edid = "U32J59x", mode = "3840x2160@60", scale = 1.25, left_width = 3840 / 1.25 },
}

-- Connected panels are read straight from DRM sysfs, not from hyprctl: the config is
-- parsed before the compositor's IPC socket exists, so on a cold boot hyprctl has
-- nothing to answer with. `grep -lx` avoids matching the word "disconnected".
-- Global so monitors.lua can rescan on hotplug. One entry per connected panel other
-- than the laptop's own: { card = "card2", connector = "HDMI-A-1", edid = <blob> }.
function connected_externals()
    local found = {}
    local list = io.popen("grep -lx connected /sys/class/drm/card*-*/status 2>/dev/null")
    if not list then return found end
    for status_path in list:lines() do
        local card, connector = status_path:match("/(card%d+)%-(.-)/status$")
        if card and not connector:find("^eDP") then
            local f = io.open((status_path:gsub("/status$", "/edid")), "rb")
            found[#found + 1] = { card = card, connector = connector, edid = f and f:read("a") or "" }
            if f then f:close() end
        end
    end
    list:close()
    return found
end

-- Identifies a set of connected panels, to tell whether a hotplug changed anything.
function externals_key(externals)
    local names = {}
    for _, ext in ipairs(externals) do names[#names + 1] = ext.card .. "-" .. ext.connector end
    table.sort(names)
    return table.concat(names, ",")
end

-- DRM card of each GPU, by kernel driver. Card numbers can change between boots, so
-- they are looked up every time the config is evaluated rather than hardcoded.
IGPU_CARD, DGPU_CARD = nil, nil
local drivers = io.popen("grep -H '^DRIVER=' /sys/class/drm/card[0-9]*/device/uevent 2>/dev/null")
if drivers then
    for line in drivers:lines() do
        local card, driver = line:match("/(card%d+)/device/uevent:DRIVER=(%S+)")
        if driver == "nvidia" then
            DGPU_CARD = card
        elseif driver == "i915" or driver == "xe" then
            IGPU_CARD = card
        end
    end
    drivers:close()
end

function external_on_dgpu(externals)
    for _, ext in ipairs(externals) do
        if ext.card == DGPU_CARD then return true end
    end
    return false
end

local function block(first, count)
    local ws = {}
    for i = 1, count do ws[i] = first + i - 1 end
    return ws
end

local externals = connected_externals()
EXTERNALS_KEY    = externals_key(externals)
EXTERNAL_ON_DGPU = external_on_dgpu(externals)

-- Derived: consumed by workspaces.lua (one rule per workspace).
-- The first workspace listed for a monitor becomes that monitor's default.
WS_LAYOUT = { { monitor = MONITOR1, workspaces = block(1, LAPTOP_WS) } }

-- Derived: consumed by monitors.lua. X of the laptop panel, non-zero when a connected
-- external sits to its left.
LAPTOP_X = 0

local next_ws = LAPTOP_WS + 1
for _, plugged in ipairs(externals) do
    local monitor = plugged.connector
    for _, ext in ipairs(EXTERNALS) do
        if ext.monitor ~= "" and plugged.edid:find(ext.edid, 1, true) then
            monitor = ext.monitor
            if ext.left_width then LAPTOP_X = ext.left_width end
            break
        end
    end
    WS_LAYOUT[#WS_LAYOUT + 1] = {
        monitor    = monitor,
        workspaces = block(next_ws, EXTERNAL_WS),
    }
    next_ws = next_ws + EXTERNAL_WS
end

NUM_MONITORS = #WS_LAYOUT

-- SUPER+1..9,0 always address workspaces 1..10, whatever is plugged in. A workspace
-- past every pinned block (e.g. 4+ with the laptop alone) has no rule, so it opens on
-- the focused monitor.
NUM_WS = 10
