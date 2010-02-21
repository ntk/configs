-- {{{ Libraries
require("awful")
require("awful.rules")
require("awful.autofocus")
-- User libraries
--require("teardrop")
--require("scratchpad")
-- }}}

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- load theme
-- theme_path = "/usr/share/awesome/themes/zenburn/theme.lua"
-- beautiful.init(theme_path)
beautiful.init(awful.util.getdir("config") .. "/themes/zenburn.lua")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

-- Window titlebars
use_titlebar = false -- True for floaters (manage signal)

-- Window management layouts
layouts = {
    awful.layout.suit.tile,            -- 1
    awful.layout.suit.tile.left,       -- 2
    awful.layout.suit.tile.bottom,     -- 3
    awful.layout.suit.tile.top,        -- 4
    awful.layout.suit.fair,            -- 5
    awful.layout.suit.fair.horizontal, -- 6
--  awful.layout.suit.spiral,          -- /
--  awful.layout.suit.spiral.dwindle,  -- /
    awful.layout.suit.max,             -- 7
--  awful.layout.suit.max.fullscreen,  -- /
    awful.layout.suit.magnifier,       -- 8
    awful.layout.suit.floating         -- 9
}
-- }}}

-- {{{ Menu
mymainmenu = awful.menu({ items = { --{ "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

require("panel")
require("keys")
require("apprules")

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar to each client if enabled globaly
--    if use_titlebar then
--        awful.titlebar.add(c, { modkey = modkey })
    -- Floating clients always have titlebars
--    elseif awful.client.floating.get(c)
--        or awful.layout.get(c.screen) == awful.layout.suit.floating then
--            if not c.titlebar and c.class ~= "Xmessage" then
--                awful.titlebar.add(c, { modkey = modkey })
--            end
            -- Floating clients are always on top
--            c.above = true
--    end

    if awful.client.floating.get(c) then
            c.above = true
    end

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Set new clients as slaves
    --awful.client.setslave(c)

    -- New floating windows:
    --   - don't cover the wibox
      awful.placement.no_offscreen(c)
    --   - don't overlap until it's unavoidable
      awful.placement.no_overlap(c)
    --   - are centered on the screen
    --awful.placement.centered(c, c.transient_for)

    -- Honoring of size hints
    --   - false will remove gaps between windows
    c.size_hints_honor = false
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
