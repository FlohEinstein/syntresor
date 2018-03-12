#!/bin/bash
export DISPLAY=:1
Xvfb :1 -screen 0 1600x900x16 &
sleep 5
openbox-session&
if [ "${VNCPASSWORD}" != "" ]; then 
	x11vnc -storepasswd ${VNCPASSWORD} /home/tresorit/.x11vnc/passwd
	x11vnc -display :1 -rfbauth /home/tresorit/.x11vnc/passwd -listen localhost -xkb -ncache 10 -ncache_cr -forever &

	if [ "${NOVNCPORT}" = "" ]; then export NOVNCPORT=6080
	fi
	if [ "${NOVNCCERT}" != "none" ]; then export NOVNCCERTPARAM="--cert ${NOVNCCERT}"
	fi
	if [ "${NOVNCSSLONLY}" = "true" ]; then export NOVNCSSLPARAM="--ssl-only"
	fi
	/home/tresorit/noVNC/utils/launch.sh --listen ${NOVNCPORT} $NONVCCERTPARAM ${NOVNCSSLPARAM} --vnc localhost:5900 &
	/home/tresorit/tresorit
else
	/home/tresorit/tresorit
fi
