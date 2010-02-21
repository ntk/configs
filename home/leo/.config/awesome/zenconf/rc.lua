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
mymainmenu = awful.menu({ items = {
  --{ "awesome", myawesomemenu, beautiful.awesome_icon },
  { "open terminal", terminal },
  { "restart", awesome.restart },
  { "quit", awesome.quit } }})

  -- mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
  --                                      menu = mymainmenu })
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}

tags.settings = {
    { name = "1:term",  layout = layouts[1]  },
    { name = "2:vim",   layout = layouts[1]  },
    { name = "3:web",   layout = layouts[1]  },
    { name = "4:mail",  layout = layouts[8]  },
    { name = "5:im",    layout = layouts[2], mwfact = 0.82 },
    { name = "6",     layout = layouts[1], hide = true },
    { name = "7",     layout = layouts[1], hide = true },
    { name = "8:rss",   layout = layouts[1] },
    { name = "9:misc", layout = layouts[1]  }
}

-- Initialize tags
for s = 1, screen.count() do
    tags[s] = {}
    for i, v in ipairs(tags.settings) do
        tags[s][i] = tag({ name = v.name })
        tags[s][i].screen = s
        awful.tag.setproperty(tags[s][i], "layout",  v.layout)
        awful.tag.setproperty(tags[s][i], "mwfact",  v.mwfact)
        awful.tag.setproperty(tags[s][i], "hide",    v.hide)
        awful.tag.setproperty(tags[s][i], "nmaster", v.nmaster)
        awful.tag.setproperty(tags[s][i], "ncols",   v.ncols)
    end
    tags[s][1].selected = true
end

-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

require("panel")

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- {{{ Prompt menus
    awful.key({ modkey }, "r", function ()
        awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen].widget,
            function (...) promptbox[mouse.screen].text = awful.util.spawn(unpack(arg), false) end,
            awful.completion.shell, awful.util.getdir("cache") .. "/history")
    end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  promptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "a",      function (c) c.above = not c.above            end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, i,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, i,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, i,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, i,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
-- }}}

-- {{{ Aplication rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = true,
          keys = clientkeys,
          buttons = clientbuttons
    }},
    -- Application specific behaviour
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
--    { rule = { class = "vlc" },
--      properties = { floating = true } },
--    { rule = { name = "VLC media player" },
--      properties = { floating = true } },
    -- Set Firefox to always map on tags number 3 of current screen.
    { rule = { class = "Shiretoko" },
      properties = { tag = tags[screen.count()][3] } },
    { rule = { class = "Firefox", instance = "Download" },
      properties = { floating = true } },
    { rule = { class = "Claws-mail" },
      properties = { tag = tags[screen.count()][4] } },
    { rule = { class = "Pidgin" },
      properties = { tag = tags[screen.count()][5] } },
}
-- }}}

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

-- vim:filetype=lua:tabstop=8:shiftwidth=2:fdm=marker:
