local vars = require("modules.variables")
local mainMod = vars.mainMod
local workspaceMode = vars.workspaceMode
local terminal = vars.terminal
local fileManager = vars.fileManager
local appLauncher = vars.appLauncher

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + X", hl.dsp.window.close())
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("swaylock"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("wlogout --protocol layer-shell"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(appLauncher .. " -show drun"))
hl.bind(mainMod .. " + U", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

for i = 1, 9 do
	hl.bind(workspaceMode .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(workspaceMode .. " + " .. mainMod .. " + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(workspaceMode .. " + ALT + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(workspaceMode .. " + ALT + left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(workspaceMode .. " + ALT + up", hl.dsp.focus({ workspace = "empty" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("killall waybar || waybar"))

hl.bind("SUPER + M", hl.dsp.exec_cmd("hyprlock"))

hl.bind("SUPER + L", hl.dsp.exit())

hl.bind("SUPER + B", hl.dsp.exec_cmd("sh ~/.config/hypr/scripts/change_bg.sh"))

hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("sh ~/.config/hypr/scripts/volume_control.sh"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
	{ locked = true, release = true }
)
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"),
	{ locked = true, release = true }
)

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s +2%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 2%-"), { locked = true, repeating = true })

hl.bind(mainMod .. " + C", hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + B", hl.dsp.window.fullscreen())

hl.bind(
	"Print",
	hl.dsp.exec_cmd([[grim - | satty --filename - --output-filename ~/Pictures/satty-$(date '+%Y%m%d-%H:%M:%S').png]])
)
hl.bind(
	mainMod .. " + Print",
	hl.dsp.exec_cmd(
		[[grim -g "$(slurp -w 0)" - | satty --filename - --output-filename ~/Pictures/satty-$(date '+%Y%m%d-%H:%M:%S').png]]
	)
)

hl.bind("SUPER + SPACE", hl.dsp.exec_cmd('echo "" > /tmp/hypr-submap'))

hl.bind("SUPER + SPACE", hl.dsp.submap("gaming"))

hl.define_submap("gaming", function()
	hl.bind("SUPER + SPACE", hl.dsp.exec_cmd('echo "" > /tmp/hypr-submap'))
	hl.bind("SUPER + SPACE", hl.dsp.submap("reset"))
end)
