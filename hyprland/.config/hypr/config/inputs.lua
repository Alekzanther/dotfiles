-- Input configuration

hl.config({
    input = {
        -- sensitivity = -0.25,
        accel_profile = "flat",
        -- us first: new windows default to layout 0 (see binds.lua + autostart.lua).
        kb_layout = "us,se",
        -- Caps Lock acts as Escape (no Caps Lock toggle remains).
        kb_options = "caps:escape",
        touchpad = {
            -- Content follows the fingers, macOS-style.
            natural_scroll = true,
        },
    },
    -- Uncomment the section below to enable software cursors; this can help with cursor display or behavior issues
    -- cursor = {
    --     no_hardware_cursors = 1,
    -- },
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down",       action = "close" })
hl.gesture({ fingers = 3, direction = "up",         action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left",       action = "float" })
