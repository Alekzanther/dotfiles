hl.config({
    dwindle = {
        preserve_split = true,
    },
    misc = {
        col = {
            splash = CACHYLGREEN,
        },
        middle_click_paste = false,
        enable_swallow = true,
        swallow_regex = "(kitty|ghostty|[Kk]onsole|Alacritty|gnome-terminal|xfce[0-9]?-terminal)",
        -- 3 = fullscreen_game: only fullscreen clients that tag their content type.
        -- Avoids the blank-screen mode switch when e.g. an image viewer goes fullscreen.
        vrr = 3,
    },
    cursor = {
        -- Auto disables hardware cursors whenever two GPUs are registered, which is
        -- always the case on this hybrid laptop even when only the iGPU drives outputs.
        -- Without this, every cursor move forces a full recomposite of the 4K external.
        no_hardware_cursors = 0,
    },
    render = {
        -- 2 = auto: let fullscreen clients bypass compositing. Default 0 blocked it
        -- outright (monitors reported directScanoutBlockedBy: user settings).
        direct_scanout = 2,
        new_render_scheduling = true,
    },
    xwayland = {
        force_zero_scaling = true
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})