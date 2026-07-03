local vars = require("modules.variables")

hl.window_rule({
  name = "bluetooth_control",
  float = true,
  match = { class = vars.bluetoothGui },
})

hl.window_rule({
  name = "qpwgraph_config",
  float = true,
  size = "1000 600",
  match = { class = "org\\.rncbc\\.qpwgraph$" },
})

hl.window_rule({
  name = "satty",
  float = true,
  size = "1200 600",
  match = { class = "com\\.gabm\\.satty$" },
})

hl.window_rule({
  name = "steam_friends",
  float = true,
  size = "650 812",
  move = "1265 212",
  match = { class = "steam$", title = "Friends List$" },
})

hl.window_rule({
  name = "file_roller",
  float = true,
  match = { class = "org.gnome.FileRoller$" },
})

hl.window_rule({
  name = "calculator_main",
  float = true,
  size = "673 806",
  match = { class = "org.gnome.Calculator$" },
})

hl.window_rule({
  name = "fm_opacity",
  opacity = "0.8 0.8",
  match = { class = vars.fileManager },
})

hl.window_rule({
  name = "godot_popups",
  float = true,
  match = { class = "Godot$", title = "Create New Node$" },
})

hl.window_rule({
  name = "pavucontrol",
  float = true,
  size = "1000 600",
  match = { class = "org.pulseaudio.pavucontrol$" },
})

hl.window_rule({
  name = "mozaik_rule",
  float = true,
  size = "1200 800",
  match = { class = "mozaik$", title = "Mozaik - Rule Manager$" },
})

