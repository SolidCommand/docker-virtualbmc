#!/bin/sh

if [ "$1" = "vbmcd" ]; then
	echo "Starting VirtualBMC daemon"
	/usr/local/bin/vbmcd --foreground &
	trap 'echo "Stopping VirtualBMC daemon"; kill -SIGTERM "$!"' SIGINT SIGTERM
	wait
else
	exec "$@"
fi
