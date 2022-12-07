#!/usr/bin/env python3
import pyudev
import time
from gi.repository import Gio, GLib

model = "Keychron_K2"
layouts1 = [("xkb", "qwertyfr"), ("xkb", "fr+oss")]
layouts2 = [("xkb", "fr+oss"), ("xkb", "qwertyfr")]
settings = Gio.Settings.new("org.gnome.desktop.input-sources")

def change_layout(device):
    try:
        if device.properties["ID_USB_MODEL"] != model:
            return
        if device.properties["ACTION"] == "add":
            print(f"setting keyboard layouts to {layouts1}")
            settings.set_value("mru-sources", GLib.Variant("a(ss)", layouts1))
        elif device.properties["ACTION"] == "remove":
            print(f"setting keyboard layouts to {layouts2}")
            settings.set_value("mru-sources", GLib.Variant("a(ss)", layouts2))
    except KeyError:
        pass


monitor = pyudev.Monitor.from_netlink(pyudev.Context())
monitor.filter_by("input")

for device in iter(monitor.poll, None):
    change_layout(device)
