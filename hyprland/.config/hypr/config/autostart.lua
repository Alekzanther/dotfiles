-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

-- Absolute path: ~/.local/bin is not in the Hyprland session PATH.
local PER_WINDOW_LAYOUT = os.getenv("HOME") .. "/.local/bin/hyprland-per-window-keyboard-layout"

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("xhost +SI:localuser:root")
    hl.exec_cmd(PER_WINDOW_LAYOUT)
end)
