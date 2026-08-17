-- Hyprland configuration -- Catppuccin Macchiato
-- For Fedora 42 (KDE Coexistence)
--
-- Ported from hyprland.conf (hyprlang), which is deprecated since Hyprland 0.55
-- and will be removed. See https://hypr.land/news/26_lua/
--
-- The old hyprland.conf is kept as a fallback: Hyprland loads hyprland.lua in
-- preference to it, so renaming this file away restores the old config.
--
-- Docs: https://wiki.hypr.land/Configuring/Start/

local c = require("macchiato")

local mainMod = "SUPER"

--------------------------------------------------------------------------------
-- MONITORS
-- https://wiki.hypr.land/Configuring/Basics/Monitors/
--------------------------------------------------------------------------------

hl.monitor({ output = "DP-1", mode = "preferred", position = "0x0",    scale = 1 })
hl.monitor({ output = "DP-2", mode = "preferred", position = "2560x0", scale = 1 })

-- Fallback for any monitor not matched above (empty output = catch-all).
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Pin workspaces to monitors.
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
hl.workspace_rule({ workspace = "1", monitor = "DP-2" })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-2" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-2" })

--------------------------------------------------------------------------------
-- AUTOSTART
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
--------------------------------------------------------------------------------

hl.on("hyprland.start", function()
    -- Ensure the D-Bus environment is set up for portals
    hl.exec_cmd("dbus-update-activation-environment --systemd --all && systemctl --user import-environment DISPLAY WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE")

    -- KDE Polkit agent
    hl.exec_cmd("/usr/libexec/kf6/polkit-kde-authentication-agent-1")

    -- Hand the session environment to the pam_kwallet5 helper, which is holding our
    -- login password on $PAM_KWALLET5_LOGIN. It then unlocks kdewallet via ksecretd.
    -- Plasma does this through plasma-kwallet-pam.service and /etc/xdg/autostart,
    -- neither of which Hyprland processes -- so without this the wallet stays locked.
    hl.exec_cmd("/usr/libexec/pam_kwallet_init")

    -- Autostart necessary services and applications
    hl.exec_cmd("waybar")                                        -- status bar
    hl.exec_cmd("hyprpaper")                                     -- wallpaper
    hl.exec_cmd("dunst")                                         -- notification daemon
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland")
    hl.exec_cmd("wl-paste --watch cliphist store")               -- clipboard history

    -- Start 1Password ourselves so it outlives Chrome. Otherwise the Chrome extension
    -- spawns it on demand, it dies with Chrome, and every cold start demands the
    -- account password. Forced to XWayland (Electron blanks its surface on Hyprland).
    hl.exec_cmd("env ELECTRON_OZONE_PLATFORM_HINT=x11 /opt/1Password/1password --silent")
end)

--------------------------------------------------------------------------------
-- ENVIRONMENT VARIABLES
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
--------------------------------------------------------------------------------

-- For AMD, usually no specific GPU variables are needed unless you have multiple GPUs
-- hl.env("AQ_DRM_DEVICES", "/dev/dri/card0")

-- XDG environment (Hyprland usually handles this, but explicit is safer for portals)
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE",    "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Qt theming
hl.env("QT_QPA_PLATFORMTHEME", "kde")           -- or qt6ct, depending on what you configure
hl.env("QT_QPA_PLATFORM", "wayland;xcb")        -- prefer Wayland for Qt apps
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- GTK theming (usually handled by daemons or portals, but can be set)
-- hl.env("QT_STYLE_OVERRIDE", "Catppuccin-Macchiato-Teal")

-- Chrome/Chromium platform hint (prevents crash on workspace move)
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- For the existing KDE environment, KDE service integration is mostly handled by
-- xdg-desktop-portal-hyprland and its config, to use KDE file pickers:
-- ~/.config/xdg-desktop-portal/hyprland-portals.conf

--------------------------------------------------------------------------------
-- LOOK AND FEEL
-- https://wiki.hypr.land/Configuring/Basics/Variables/
--------------------------------------------------------------------------------

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,

        -- Mauve -> Teal gradient for the active border, Surface0 for inactive
        col = {
            active_border   = {
                colors = { "rgba(" .. c.mauve .. "ee)", "rgba(" .. c.teal .. "ee)" },
                angle  = 45,
            },
            inactive_border = "rgba(" .. c.surface0 .. "dd)",
        },

        layout = "dwindle",

        -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/
        allow_tearing = false,
    },

    decoration = {
        rounding = 8,

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 3,
            new_optimizations = true,
            ignore_opacity    = true,
            xray              = false,
        },
    },

    animations = {
        enabled = true,
    },
})

--------------------------------------------------------------------------------
-- ANIMATIONS
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
--------------------------------------------------------------------------------

hl.curve("myBezier",  { type = "bezier", points = { { 0.05, 0.9  }, { 0.10, 1.05 } } })
hl.curve("linear",    { type = "bezier", points = { { 0.00, 0.0  }, { 1.00, 1.00 } } })
hl.curve("slow",      { type = "bezier", points = { { 0.10, 0.1  }, { 0.50, 0.90 } } })
hl.curve("overshot",  { type = "bezier", points = { { 0.13, 0.99 }, { 0.29, 1.10 } } })
hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.7  }, { 0.10, 1.00 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier",  style = "slide" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "md3_decel", style = "slide" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "linear" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "linear" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "md3_decel" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "md3_decel", style = "slide" })

--------------------------------------------------------------------------------
-- LAYOUTS
-- https://wiki.hypr.land/Configuring/Layouts/
--------------------------------------------------------------------------------

hl.config({
    dwindle = {
        preserve_split       = true, -- You probably want this
        force_split          = 0,    -- 0: split follows mouse, 1: left/top, 2: right/bottom
        special_scale_factor = 0.8,
    },

    master = {
        new_on_top           = false,
        special_scale_factor = 0.8,
    },
})

--------------------------------------------------------------------------------
-- INPUT
--------------------------------------------------------------------------------

hl.config({
    input = {
        kb_layout  = "ch", -- Swiss layout
        kb_variant = "de", -- German variant for Swiss layout (de_CH)
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse       = 1,    -- focus follows mouse
        numlock_by_default = true, -- enable numpad by default

        sensitivity   = 0, -- -1.0 to 1.0, 0 means no modification
        accel_profile = "flat",

        touchpad = {
            natural_scroll       = false,
            disable_while_typing = true,
        },
    },
})

--------------------------------------------------------------------------------
-- MISCELLANEOUS
--------------------------------------------------------------------------------

hl.config({
    misc = {
        force_default_wallpaper  = 0, -- 0 or 1 disables the anime mascot wallpapers
        disable_hyprland_logo    = false,
        disable_splash_rendering = false,
        mouse_move_enables_dpms  = true,
        animate_manual_resizes   = false,
        enable_swallow           = false,
        swallow_regex            = "^(kitty|alacritty|foot)$",

        -- Honor xdg-activation requests so apps can raise their own window.
        -- Needed for 1Password to appear when the Chrome extension asks it to unlock.
        focus_on_activate = true,
    },
})

--------------------------------------------------------------------------------
-- BINDS (KEYBINDINGS)
-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- https://wiki.hypr.land/Configuring/Basics/Dispatchers/
--------------------------------------------------------------------------------

-- Applications
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("alacritty"))                 -- terminal
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("rofi -show drun"))           -- launcher
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin --platformtheme kde"))

-- Window management
hl.bind(mainMod .. " + Q",     hl.dsp.window.close())                            -- close active window
hl.bind(mainMod .. " + F",     hl.dsp.window.fullscreen({ mode = "fullscreen" })) -- toggle fullscreen
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float())                            -- toggle floating
hl.bind(mainMod .. " + P",     hl.dsp.window.pseudo())                           -- toggle pseudotile

-- Move focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))
-- Or use HJKL for VIM-like navigation
-- hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left"  }))
-- hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
-- hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up"    }))
-- hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down"  }))

-- Move active window
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left"  }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up"    }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down"  }))

-- Workspaces, and moving the active window to a workspace
for i = 1, 5 do
    hl.bind(mainMod .. " + " .. i,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i,   hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll.
-- "e" = open workspaces, across all monitors. The old config used "m+1"/"m-1"
-- ("open workspaces on the *current monitor*"), which was a silent no-op: the
-- workspace rules above pin 1/3/5 to DP-2 and 2/4 to DP-1, so each monitor
-- rarely has more than one open workspace to move between.
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media control
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Requires playerctl
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"),       { locked = true })

-- Exit Hyprland
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())

-- Lock screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" ~/Pictures/Screenshot_$(date +'%Y%m%d_%H%M%S').png]]))

--------------------------------------------------------------------------------
-- WINDOW RULES
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
--
-- Left as anonymous rules on purpose: named rules are all evaluated *before*
-- anonymous ones, so mixing the two would silently change precedence.
--------------------------------------------------------------------------------

hl.window_rule({ match = { class = "^(pavucontrol)$" },            float = true }) -- PulseAudio Volume Control
hl.window_rule({ match = { class = "^(blueman-manager)$" },        float = true }) -- Blueman
hl.window_rule({ match = { class = "^(lxappearance)$" },           float = true }) -- LXAppearance
hl.window_rule({ match = { title = "^(Open File)$" },              float = true }) -- generic file dialogs
hl.window_rule({ match = { title = "^(Select File)$" },            float = true })
hl.window_rule({ match = { title = "^(Save File)$" },              float = true })
hl.window_rule({ match = { title = "^(Volume Control)$" },         float = true })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" },     float = true })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-kde)$" }, float = true }) -- KDE portal dialogs
hl.window_rule({ match = { class = "^(steam_app_.*)$" },           fullscreen = true })

-- Opacity for specific apps
hl.window_rule({ match = { class = "^(kitty)$" },     opacity = "0.9 override 0.9 override" })
hl.window_rule({ match = { class = "^(Alacritty)$" }, opacity = "0.9 override 0.9 override" })
hl.window_rule({ match = { class = "^(foot)$" },      opacity = "0.9 override 0.9 override" })
