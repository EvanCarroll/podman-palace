#!/bin/bash
set -euo pipefail

PALACE_DIR="${1:-$(pwd)/Palace-linux-x64}"

podman run --rm -it \
  --name palace \
  --hostname "$(hostname)" \
  --network=host \
  -e DISPLAY="$DISPLAY" \
  -e XAUTHORITY=/tmp/.Xauthority \
  -v "${XAUTHORITY:-$HOME/.Xauthority}":/tmp/.Xauthority:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket:ro \
  --userns=keep-id:uid=1000,gid=1000 \
  -v "$PALACE_DIR":/app/Palace-linux-x64:ro,exec \
  --device /dev/dri \
  --ipc=host \
  --security-opt label=disable \
  palace-runtime
