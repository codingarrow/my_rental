

Notes

The app binds to 0.0.0.0 inside the container (set in app.py) so the mapped port is reachable from the host — this is required for containers and is already configured.
No database, no Node, no build tooling. Keeping it simple on purpose (KISS).


OPTION 1 Running it assuming the original README was followed no PODMAN  plain python

pip install -r requirements.txt
python app.py


##############################################################################
Podman?
Running in a container means anyone can start the exact same app with one command — no "works on my machine" issues, no fiddling with Python versions or virtual environments. Podman is a drop-in, daemonless alternative to Docker (the commands are nearly identical).


Requirements
You only need two things installed on the host:

Software	Version	        Purpose	                                     Check it's installed

Podman	        4.x or newer	Builds and runs the container	             podman --version
Bash	        any	        Runs rebuild.sh (built into macOS/Linux; 
                                on Windows use WSL or Git Bash)	             bash --version

Everything else (Python 3.12, Flask) is installed inside the container automatically from the Dockerfile — you do not need Python installed on the host for Option 2.

Installing Podman
macOS: brew install podman then podman machine init && podman machine start
Fedora / RHEL: sudo dnf install podman
Ubuntu / Debian: sudo apt install podman
Windows: install Podman Desktop, or run this inside WSL2


##############################################################################

OPTION 2 Running it with PODMAN
From the project folder:

chmod +x rebuild.sh   # only needed the first time
./rebuild.sh


##############################################################################

Then open http://localhost:5000 in your browser.

That's it. The script builds the image, stops any old copy, and starts the app on port 5000.

What rebuild.sh does (?)
Removes any existing equipment-rental container.
Builds a fresh image from the Dockerfile.
Runs the container:
Maps host port 5000 → container port 5000 (-p 5000:5000).
Mounts bookings.json from the host into the container (-v), so bookings persist even after you rebuild.


Useful OPTION 2 commands

# See if the container is running
podman ps

# View live logs (helpful for debugging)
podman logs -f equipment-rental

# Stop the app
podman stop equipment-rental

# Start it again (without rebuilding)
podman start equipment-rental

# Remove it entirely
podman rm -f equipment-rental


Troubleshooting

Problem	                                        Likely cause / fix

port is already allocated           	         Something else is on port 5000. Stop it, or change HOST_PORT in rebuild.sh.

permission denied on bookings.json	         On SELinux systems the :z flag in the mount handles this — make sure it's present (it is in the provided rebuild.sh).

Bookings disappear after rebuild	         The -v volume mount isn't working — confirm bookings.json exists in the project folder before running.

Can't reach localhost:5000 on macOS	         Make sure the Podman machine is running: podman machine start.

./rebuild.sh: permission denied	                 Run chmod +x rebuild.sh first.
