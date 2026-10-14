local vars = require("modules.variables")

hl.window_rule({
  name = "steam_friend_list",
  float = true,
  size = "400 700",
  move = "1500 200",
  match = { class = "steam", title = "Friends List" },
})

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

hl.window_rule({
  name = "org.gnome.fileroller_rule",
  float = true,
  match = { class = "org.gnome.FileRoller$" },
})

hl.window_rule({
  name = "blender_rule",
  float = true,
  size = "1000 800",
  move = "100 100",
  match = { class = "blender$", initial_title = "File Browser$" },
})

