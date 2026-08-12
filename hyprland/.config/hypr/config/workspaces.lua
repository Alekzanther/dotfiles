-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Add your workspace rules here. Increment the workspace number as you go. Do not have duplicate workspaces.
hl.workspace_rule({ workspace = "name:gaming", monitor = PRIMARY_MONITOR, default = true })

-- Pin workspaces to monitors according to WS_LAYOUT in variables.lua.
-- Only the first workspace of each monitor is marked default, so the monitor has
-- one unambiguous landing workspace.
for _, entry in ipairs(WS_LAYOUT) do
    if entry.monitor ~= "" then
        for i, ws in ipairs(entry.workspaces) do
            hl.workspace_rule({
                workspace  = tostring(ws),
                monitor    = entry.monitor,
                default    = i == 1,
                persistent = true,
            })
        end
    end
end