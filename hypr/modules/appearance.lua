-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 0,

		border_size = 2,

		col = {
			active_border = "rgb(cdd6f4)",
			inactive_border = "rgba(595959aa)",
		},

		layout = "dwindle",
	},

	misc = {
		force_default_wallpaper = 1,
	},

	decoration = {
		rounding = 10,

		blur = {
			enabled = true,
			size = 7,
			passes = 3,
		},

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},
	},

	animations = {
		enabled = true,
	},
})

hl.config({
	cursor = {
		no_warps = false,
	},
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true, -- you probably want this
	},
})
