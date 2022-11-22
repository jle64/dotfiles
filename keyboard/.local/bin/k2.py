#!/usr/bin/env python3
import pyudev
import time
from gi.repository import Gio, GLib

model = "Keychron_K2"
layouts1 = [("xkb", "fr+us"), ("xkb", "fr+oss")]
layouts2 = [("xkb", "fr+oss"), ("xkb", "fr+us")]
settings = Gio.Settings.new("org.gnome.desktop.input-sources")

def change_layout(action, device):
    try:
        if device.properties["ID_USB_MODEL"] != model:
            return
        if device.properties["ACTION"] == "bind":
            print(f"setting keyboard layouts to {layouts1}")
            settings.set_value("sources", GLib.Variant("a(ss)", layouts1))
        elif device.properties["ACTION"] == "remove":
            print(f"setting keyboard layout to {layouts2}")
            settings.set_value("sources", GLib.Variant("a(ss)", layouts2))
    except KeyError:
        pass


monitor = pyudev.Monitor.from_netlink(pyudev.Context())
observer = pyudev.MonitorObserver(monitor, change_layout)
observer.start()

while True:
    time.sleep(1)
