require("vicious")

-- {{{ Wibox
--
-- {{{ Widgets configuration
--
-- {{{ Reusable separators
spacer         = widget({ type = "textbox", name = "spacer" })
separator      = widget({ type = "textbox", name = "separator" })
spacer.text    = " "
separator.text = "|"
-- }}}

-- {{{ CPU usage and temperature
-- Widget icon
cpuicon        = widget({ type = "imagebox", name = "cpuicon" })
cpuicon.image  = image(beautiful.widget_cpu)
-- Initialize widgets
cpuwidget      = awful.widget.graph({ layout = awful.widget.layout.horizontal.rightleft })
-- Graph properties
cpuwidget:set_width(50)
cpuwidget:set_scale(false)
cpuwidget:set_max_value(100)
cpuwidget:set_background_color(beautiful.fg_off_widget)
cpuwidget:set_border_color(beautiful.border_widget)
cpuwidget:set_color(beautiful.fg_end_widget)
cpuwidget:set_gradient_colors({
    beautiful.fg_end_widget,
    beautiful.fg_center_widget,
    beautiful.fg_widget })
-- Register widgets
vicious.register(cpuwidget, vicious.widgets.cpu, "$1")
-- }}}

-- {{{ Battery state
-- Widget icon
baticon       = widget({ type = "imagebox", name = "baticon" })
baticon.image = image(beautiful.widget_bat)
-- Initialize widget
batwidget     = widget({ type = "textbox", name = "batwidget" })
-- Register widget
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
-- }}}

-- {{{ Date and time
-- Initialize widget
datewidget     = widget({ type = "textbox", name = "datewidget" })
-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%b %e, %R", 61)
-- Register buttons
datewidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn("pylendar.py", false) end)))
-- }}}

-- {{{ System tray
systray = widget({ type = "systray" })
-- }}}
-- }}}

-- {{{ Wibox initialisation
wibox     = {}
promptbox = {}
layoutbox = {}
taglist   = {}
taglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev))

for s = 1, screen.count() do
    -- Create a promptbox
    promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create a layoutbox
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create the taglist
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)
    -- Create the wibox
    wibox[s] = awful.wibox({
        position = "top", height = 14, screen = s,
        fg = beautiful.fg_normal, bg = beautiful.bg_normal
    })
    -- Add widgets to the wibox
    wibox[s].widgets = {{
        taglist[s],
        layoutbox[s],
        promptbox[s],
        layout = awful.widget.layout.horizontal.leftright
    },
        s == screen.count() and systray or nil,
        spacer, datewidget,
        spacer, separator,
        spacer, batwidget, baticon,
        separator,
        cpuwidget.widget, spacer, cpuicon, separator,
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}
-- }}}

