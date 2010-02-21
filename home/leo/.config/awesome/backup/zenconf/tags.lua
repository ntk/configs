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

