#!/bin/sh

if [ "$1" = "vbmcd" ]; then
	# Clean up old pid files.
	if [ -f "/virtualbmc/.vbmc/master.pid" ];then
		echo "Removing old PID file."
		rm -f /virtualbmc/.vbmc/master.pid
	fi
	echo "Starting VirtualBMC daemon"
	/usr/bin/vbmcd --foreground &
	trap 'echo "Stopping VirtualBMC daemon"; kill -SIGTERM "$!"' SIGINT SIGTERM
	wait
else
	exec "$@"
fi
