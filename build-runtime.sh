#!/bin/bash
set -euo pipefail

ctr=$(buildah from docker.io/ubuntu:latest)

buildah run "$ctr" -- env DEBIAN_FRONTEND=noninteractive \
	apt-get update

buildah run "$ctr" -- env DEBIAN_FRONTEND=noninteractive \
	apt-get install -y --no-install-recommends \
	libglib2.0-dev \
	libnspr4 \
	libnss3 \
	libatk1.0-dev \
	libatk-bridge2.0-dev \
	libcups2-dev \
	libgtk-3-dev \
	libasound-dev \
	libpulse0 \
	dbus \
	libdbus-1-3 \
	xdg-utils

buildah run "$ctr" -- rm -rf /var/lib/apt/lists/*

buildah run "$ctr" -- userdel ubuntu
buildah run "$ctr" -- useradd --create-home --shell /bin/bash --uid 1000 palaceapp
buildah config --user palaceapp "$ctr"
buildah config --workingdir /app/Palace-linux-x64 "$ctr"
buildah config --cmd ./Palace "$ctr"

buildah commit "$ctr" palace-runtime
buildah rm "$ctr"

echo "Image 'palace-runtime' built successfully."
