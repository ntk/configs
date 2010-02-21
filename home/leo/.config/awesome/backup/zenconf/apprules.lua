-- {{{ Rules
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
