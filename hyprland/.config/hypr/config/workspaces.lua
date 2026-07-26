-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Add your workspace rules here. Increment the workspace number as you go. Do not have duplicate workspaces.
hl.workspace_rule({ workspace = "name:gaming", monitor = PRIMARY_MONITOR, default = true })

-- Pin NUM_WPM workspaces to each connected monitor, numbered consecutively
-- (MONITOR1 first). Set the monitor outputs + NUM_WPM in variables.lua.
local ws = 1
for _, mon in ipairs({ MONITOR1, MONITOR2, MONITOR3 }) do
    if mon ~= "" then
        for _ = 1, NUM_WPM do
            hl.workspace_rule({ workspace = tostring(ws), monitor = mon, default = true, persistent = true })
            ws = ws + 1
        end
    end
end