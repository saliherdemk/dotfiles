local vars = require("modules.variables")

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
	name = "audio_control",
	match = { class = vars.audioGui },
	float = true,
})

hl.window_rule({
	name = "bluetooth_control",
	match = { class = vars.bluetoothGui },
	float = true,
})

hl.window_rule({
	name = "pavucontrol_refined",
	match = { class = "^(org\\.pulseaudio\\.pavucontrol|" .. vars.audioGui .. "|org.corectrl.CoreCtrl)$" },
	float = true,
	center = true,
	size = "1000 600",
})

hl.window_rule({
	name = "qpwgraph_config",
	match = { class = "org\\.rncbc\\.qpwgraph$" },
	float = true,
	center = true,
	size = "1000 600",
})

hl.window_rule({
	name = "satty",
	match = { class = "com\\.gabm\\.satty$" },
	float = true,
	center = true,
	size = "1000 600",
})

hl.window_rule({
	name = "steam_friends",
	match = { class = "steam$", title = "Friends List$" },
	float = true,
	size = "650 812",
	move = "1265 212",
})

hl.window_rule({
	name = "file_roller",
	match = { class = "org.gnome.FileRoller$" },
	float = true,
})

hl.window_rule({
	name = "calculator_main",
	match = { class = "org.gnome.Calculator$" },
	float = true,
	center = true,
	size = "673 806",
})

hl.window_rule({
	name = "terminal_opacity",
	match = { class = vars.terminal },
	opacity = "0.8 0.8",
})

hl.window_rule({
	name = "fm_opacity",
	match = { class = vars.fileManager },
	opacity = "0.8 0.8",
})

hl.window_rule({
	name = "godot_main",
	match = { class = "Godot$" },
	tile = true,
})

hl.window_rule({
	name = "godot_popups",
	match = { class = "Godot$", title = "Create New Node$" },
	float = true,
})
