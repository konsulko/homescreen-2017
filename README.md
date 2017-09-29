This project contains:

HomeScreen: AGL Home Screen reference implementation

AGL repo for source code:

AGL repo for bitbake recipe:



Quickstart:

Instructions for building HomeScreen app
----------------------------------------

The HomeScreen app is part of the
packagegroup-agl-demo-platform
packagegroup.

This also includes the following apps:
- WindowManager
- HomeScreen Binder

And the library
- libhomescreen
- libwindowmanager


To build all the above, follow the instrucions on the AGL
documentation website:
http://docs.automotivelinux.org/docs/getting_started/en/dev/reference/source-code.html#features-supported-by-aglsetup

Please activate the "agl-demo" feature when running the aglsetup script:
http://docs.automotivelinux.org/docs/getting_started/en/dev/reference/source-code.html#features-supported-by-aglsetup


Launch HomeScreen App:

Usage: ./HomeScreen [port] [token]
AGL HomeScreen - see wwww... for more details

QT_WAYLAND_SHELL_INTEGRATION=ivi-shell LD_PRELOAD=/usr/lib/libEGL.so.1 /home/root/HomeScreen ${port} ${token}
