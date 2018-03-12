# About
syntresor - a NoVNC server allowing to use Tresorit syncing on headless systems (e.g. Synology NAS)
Based on Ubuntu Bionic, since I couldn't get Tresorit to run on alpine (thnx for making glibc necessary/removing it).

# Usage
docker run -d -p 6080:6080 -e VNCPASSWORD=mypassword -e NOVNCPORT=6080 -v /volume1:/home/tresorit/external/volume1 -v ./config/Profiles:/home/tresorit/Profiles floheinstein/syntresor

Then point your browser to http://[yourhostname]:6080/ . 
- Ignore the warning about FUSE (we don't modify files from inside the container anyway)
- setup syncing with your Tresorit credentials
- check "Remember me on this computer"

Stop the container, then start it again without the VNC environment variables and the exposed port:

docker run -d -v /volume1:/home/tresorit/external/volume1 -v ./config/Profiles:/home/tresorit/Profiles floheinstein/syntresor

You should only need to start X11vnc and noVNC when you need to reconfigure something. For this, just set the ENV variables again and expose the port.

# Volumes
/home/tresorit/Profiles: contains your credentials.
/home/tresorit/external: Just mount any synology share or other path you want to access here.

# Environment
NOVNCPORT: The port noVNC uses (default: 6080)
VNCPASSWORD: The password for VNC. If none is set, the container starts without VNC.
NOVNCCERT: If you want to use a certificate for the connection, supply a path to the PEM here, and get it inside the container somehow (untested)
NOVNCSSLONLY: Accept only encrypted connections (untested)
