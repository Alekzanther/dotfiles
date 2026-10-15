-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Example: output can be found with hyprctl monitors. Edit variables.lua for the monitor outputs instead of here directly
-- hl.monitor({
--     output    = "MONITOR1",
--     mode      = "1920x1080@60",
--     position  = "0x0",
--     scale     = "1",
-- })

hl.monitor({
    output    = MONITOR1,
    mode      = "preferred",
    position  = "auto",
    scale     = "auto",
})

-- Externals sit to the RIGHT of the laptop, so they get positive X (auto-right
-- places them relative to the already-declared MONITOR1 — keep after that block).
-- Only one external is ever plugged in; the rule for the absent one is inert.
for _, ext in ipairs(EXTERNALS) do
    if ext.monitor ~= "" then
        hl.monitor({
            output    = ext.monitor,
            mode      = ext.mode or "preferred",
            position  = "auto-right",
            scale     = ext.scale or "auto",
        })
    end
end
