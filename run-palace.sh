#!/bin/bash
set -euo pipefail

PALACE_DIR="${1:-$(pwd)/Palace-linux-x64}"

podman run --rm -it \
	--name palace \
	--hostname "$(hostname)" \
	--network=host \
	-e DISPLAY="$DISPLAY" \
	-e XAUTHORITY=/tmp/.Xauthority \
	-e DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus" \
	-v /run/user/$(id -u)/bus:/run/user/$(id -u)/bus \
	-v "${XAUTHORITY:-$HOME/.Xauthority}":/tmp/.Xauthority:ro \
	-v /tmp/.X11-unix:/tmp/.X11-unix:ro \
	-e PULSE_SERVER=unix:/run/user/$(id -u)/pulse/native \
	-v /run/user/$(id -u)/pulse/native:/run/user/1000/pulse/native:ro \
	-v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket:ro \
	-e PULSE_COOKIE=/tmp/.pulse-cookie \
	--userns=keep-id:uid=1000,gid=1000 \
	-v "$PALACE_DIR":/app/Palace-linux-x64:ro,exec \
	--device /dev/dri \
	--ipc=host \
	--security-opt label=disable \
	palace-runtime
