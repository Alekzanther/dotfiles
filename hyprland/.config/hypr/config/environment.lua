-- Environmental variables
-- if you don't use UWSM, define your variables here (e.g. hl.env("QT_QPA_PLATFORM", "wayland"))
-- This machine starts Hyprland through greetd -> start-hyprland, not UWSM, so they go here.

-- Render GPU. Hyprland defaults to the Intel iGPU, but the HDMI port is wired to the
-- NVIDIA dGPU: a panel there gets every frame rendered on Intel, copied to a linear
-- buffer and blitted across by the NVIDIA card, which makes it sluggish, and its
-- hardware-cursor blit fails outright ("Backend requires blit, but cursor blit failed").
-- With an external on the dGPU at login, render there instead: that panel becomes
-- native and the laptop panel takes the copy. The dGPU is awake to drive HDMI anyway.
-- Undocked, or on the iGPU-wired USB-C port, the iGPU keeps rendering.
-- Both cards are always listed so a panel hotplugged on either one still lights up.
-- AQ_DRM_DEVICES is only read at startup. hl.env exports it, so on a reload it is
-- already set and keeps the startup value; monitors.lua reads it to tell which GPU is
-- actually rendering.
if not os.getenv("AQ_DRM_DEVICES") and IGPU_CARD and DGPU_CARD then
    local first, second = IGPU_CARD, DGPU_CARD
    if DGPU_RENDER_WHEN_DOCKED and EXTERNAL_ON_DGPU then
        first, second = DGPU_CARD, IGPU_CARD
    end
    hl.env("AQ_DRM_DEVICES", "/dev/dri/" .. first .. ":/dev/dri/" .. second)
end
