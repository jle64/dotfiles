#!/usr/bin/env python2
# -*- coding: UTF-8 -*-

import re, subprocess, urllib2 as u
import pynotify, gobject, gtk

class Alerte():
    def __init__(self):
        pynotify.init('Alertes')
        self.previous_alerte = ''
        self.hostname = ''
        #gobject.timeout_add(0, self.main)
        #gtk.main()
        self.main()

    def get_last_alerte(self):
        url = 'http://nagios.integra.fr/nagios/lastPage.txt'
        pm = u.HTTPPasswordMgrWithDefaultRealm()
        pm.add_password(None, url, 'cedric', 'nagios')
        handler = u.HTTPBasicAuthHandler(pm)
        opener = u.build_opener(handler)
        opener.open(url)
        u.install_opener(opener)
        req = u.Request(url)
        handle = u.urlopen(req)
        result = handle.read()
        return result

    def show_error_dialog(self, text):
        error_dialog = gtk.MessageDialog(None, gtk.DIALOG_DESTROY_WITH_PARENT, \
            gtk.MESSAGE_ERROR, gtk.BUTTONS_CLOSE, text)
        response = error_dialog.run()
        if response == gtk.RESPONSE_CLOSE:
            error_dialog.destroy()

    def get_hostname(self, alerte):
        try:
            hostname = 'fr' + re.match(r'.*fr(.*) .*', alerte.lower()).group(1)
            if hostname == '': raise
        except:
            hostname = 'fr' + re.match(r'.*fr(.*)\).*', alerte.lower()).group(1)
        return hostname

    def callback(self, n, action):
        if action == "ssh":
            process = ['/usr/bin/gnome-terminal', '-e', 'ssh ' + self.hostname]
        elif action == "rdp":
            process = ['/usr/bin/rdesktop', self.hostname]
        elif action == "centreon":
            process = ['/usr/bin/xdg-open', \
                'https://centreon.itc.integra.fr/main.php?p=201&o=hd&host_name=' + self.hostname]
        elif action == "crdi":
            process = ['/usr/bin/xdg-open', 'https://intranet.itc.integra.fr/crdi/']
        try:
            subprocess.Popen(process)
        except Exception as e:
            self.show_error_dialog(\
                "Erreur en tentant d'exécuter le processus :\n\n" + e.strerror)
        n.show()

    def main(self):
        alerte = self.get_last_alerte()
        if alerte != self.previous_alerte and self.previous_alerte != 'a':
            print "Alerte : " + alerte
            n = pynotify.Notification(alerte)
            hostname = self.get_hostname(alerte)
            print "Host : " + hostname
            n.set_category("device")
            if hostname[11] == 'u':
                n.add_action("ssh", "SSH", self.callback)
            if hostname[11] == 'w':
                n.add_action("rdp", "RDP", self.callback)
            if hostname[9] == 'v':
                n.set_urgency(pynotify.URGENCY_CRITICAL)
            else:
                n.set_urgency(pynotify.URGENCY_NORMAL)
            n.add_action("centreon", "Centreon", self.callback)
            n.add_action("crdi", "CRDI", self.callback)
            n.show()
        self.previous_alerte = alerte
        gobject.timeout_add(10000, self.main)
        gtk.main()

if __name__ == '__main__':
    Alerte()
