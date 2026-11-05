-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Example: output can be found with hyprctl monitors. Edit variables.lua for the monitor outputs instead of here directly
-- hl.monitor({
--     output    = "MONITOR1",
--     mode      = "1920x1080@60",
--     position  = "0x0",
--     scale     = "1",
-- })

-- Positions are explicit. auto/auto-right place monitors in the order Hyprland
-- enumerates them, and the first one always lands at 0x0: when the dGPU renders
-- (environment.lua) its HDMI panel comes first and the laptop got pushed to the right.
-- The laptop's scale is pinned so its logical width is known: 2560 / 1.6 = 1600.
LAPTOP_LOGICAL_WIDTH = 1600

hl.monitor({
    output    = MONITOR1,
    mode      = "preferred",
    position  = LAPTOP_X .. "x0",
    scale     = 1.6,
})

-- Externals sit to the RIGHT of the laptop, flush with its right edge, unless the entry
-- has `left_width` (variables.lua): then it takes 0x0 and the laptop moves over.
-- Only one external is ever plugged in; the rule for the absent one is inert.
for _, ext in ipairs(EXTERNALS) do
    if ext.monitor ~= "" then
        hl.monitor({
            output    = ext.monitor,
            mode      = ext.mode or "preferred",
            position  = ext.left_width and "0x0" or (LAPTOP_X + LAPTOP_LOGICAL_WIDTH) .. "x0",
            scale     = ext.scale or "auto",
        })
    end
end

-- Fallback for any panel not listed in EXTERNALS (a meeting-room screen, say). Without
-- it an unknown panel on the dGPU would be placed first at 0x0, overlap the laptop,
-- and one of the two would not be registered.
hl.monitor({
    output    = "",
    mode      = "preferred",
    position  = (LAPTOP_X + LAPTOP_LOGICAL_WIDTH) .. "x0",
    scale     = "auto",
})

-- Hotplug. Workspace blocks (variables.lua) and the render GPU (environment.lua) are
-- both derived from what was plugged in when the config was evaluated, so rescan when
-- a panel comes or goes. A changed set reloads the config, which hands the new panel
-- its workspace block and mode. The render GPU only changes on a fresh login, so a
-- mismatch just gets a notice.
local function on_hotplug()
    local externals = connected_externals()
    if externals_key(externals) == EXTERNALS_KEY then return end

    local rendering_on_dgpu = DGPU_CARD ~= nil
        and (os.getenv("AQ_DRM_DEVICES") or ""):match("^[^:]*") == "/dev/dri/" .. DGPU_CARD
    local want_dgpu = DGPU_RENDER_WHEN_DOCKED and external_on_dgpu(externals)
    if want_dgpu and not rendering_on_dgpu then
        hl.notification.create({
            text = "External is on an NVIDIA port: log out and back in to render on the dGPU so it runs smoothly",
            timeout = 10000,
            icon = "info",
        })
    elseif rendering_on_dgpu and not want_dgpu then
        hl.notification.create({
            text = "Still rendering on the dGPU with no external on it: log out and back in to save battery",
            timeout = 10000,
            icon = "info",
        })
    end

    hl.exec_cmd("hyprctl reload")
end

hl.on("monitor.added", on_hotplug)
hl.on("monitor.removed", on_hotplug)
