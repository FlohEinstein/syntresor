#!/bin/bash
export DISPLAY=:1
Xvfb :1 -screen 0 1600x900x16 &
sleep 5
openbox-session&
if [ ${VNCPASSWORD} != "none" ]; then 
	mkdir -p ~/.x11vnc
	x11vnc -storepasswd ${VNCPASSWORD} ~/.x11vnc/passwd
	x11vnc -display :1 -rfbauth ~/.x11vnc/passwd -listen localhost -xkb -ncache 10 -ncache_cr -forever &
else
	x11vnc -display :1 -nopw -listen localhost -xkb -ncache 10 -ncache_cr -forever &
fi
cd /home/tresorit/noVNC && ln -s vnc.html index.html
if [ "${NOVNCPORT}" != "" ]; then 
	export NOVNCPORT=6080
fi
if [ "${NOVNCCERT}" != "none" ]; then 
	export NOVNCCERTPARAM="--cert ${NOVNCCERT}"
fi
if [ "${NOVNCSSLONLY}" = "true" ]; then
	export NOVNCSSLPARAM="--ssl-only"
fi
/home/tresorit/noVNC/utils/launch.sh --listen ${NOVNCPORT} $NONVCCERTPARAM ${NOVNCSSLPARAM} --vnc localhost:5900 &
/home/tresorit/tresorit
