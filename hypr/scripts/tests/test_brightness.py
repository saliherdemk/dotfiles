"""Run with python3 ~/.config/hypr/scripts/tests/test_brightness.py."""

import json
import os
from pathlib import Path
import subprocess
import tempfile


script = Path(__file__).resolve().parents[1] / "brightness.sh"
with tempfile.TemporaryDirectory() as directory:
    root = Path(directory)
    mock = root / "ddcutil"
    mock.write_text("""#!/bin/sh
echo "$*" >> "$XDG_RUNTIME_DIR/calls"
if [ "$1" = detect ]; then
    [ ! -f "$XDG_RUNTIME_DIR/disconnected" ] || exit 1
    echo "I2C bus:  /dev/i2c-7"
    exit 0
fi
[ "$2" = 7 ] && [ ! -f "$XDG_RUNTIME_DIR/disconnected" ] || exit 1
case " $* " in
    *" getvcp "*) echo "current value = ${BRIGHTNESS:-50}" ;;
esac
""")
    mock.chmod(0o700)
    env = dict(os.environ, PATH=f"{root}:{os.environ['PATH']}", XDG_RUNTIME_DIR=str(root))
    calls = root / "calls"
    cache = root / "waybar-brightness-bus"

    def run(action="get", brightness=50):
        calls.write_text("")
        result = subprocess.run(
            ["sh", str(script), action],
            env=dict(env, BRIGHTNESS=str(brightness)),
            capture_output=True, text=True,
        )
        return result, calls.read_text().splitlines()

    result, commands = run()
    assert result.returncode == 0 and commands.count("detect") == 1
    assert json.loads(result.stdout)["tooltip"] == "Brightness: 50 %"
    assert cache.read_text().strip() == "7"
    result, commands = run()
    assert result.returncode == 0 and "detect" not in commands
    for stale in ("99", "invalid"):
        cache.write_text(stale)
        result, commands = run()
        assert result.returncode == 0 and commands.count("detect") == 1
        assert cache.read_text().strip() == "7"
    for action, value, expected in [("+", 50, 55), ("-", 50, 45), ("+", 98, 100), ("-", 2, 0)]:
        result, commands = run(action, value)
        assert result.returncode == 0 and "detect" not in commands
        assert f"--bus 7 --sleep-multiplier 0.2 setvcp 10 {expected}" in commands
    (root / "disconnected").touch()
    result, commands = run("+")
    assert result.returncode != 0 and commands.count("detect") == 1
    assert not any("setvcp" in command for command in commands)

print("PASS: cached discovery, stale/invalid cache recovery, ±5 steps, limits, disconnection")
