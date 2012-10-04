#!/usr/bin/env python2
# -*- coding: UTF-8 -*-

import re, subprocess, urllib2 as u
import pynotify, gobject, gtk

class Alerte():
    def __init__(self):
        pynotify.init('Alertes')
        self.previous_alerte = ''
        self.hostname = ''
	self.notifications = []
        gobject.timeout_add(0, self.main)
        gtk.main()

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

    def show_error_dialog(self, primarytext, secondarytext):
        error_dialog = gtk.MessageDialog(None, gtk.DIALOG_DESTROY_WITH_PARENT, \
            gtk.MESSAGE_ERROR, gtk.BUTTONS_CLOSE, primarytext)
        error_dialog.format_secondary_text(secondarytext)
        response = error_dialog.run()
        if response == gtk.RESPONSE_CLOSE:
            error_dialog.destroy()

    def get_hostname(self, alerte):
        try:
            self.hostname = 'fr' + re.match(r'.*fr(.*?) .*', alerte.lower()).group(1)
            if self.hostname[-1] == ")": self.hostname = self.hostname[:-1]
            if self.hostname == '': raise
        except:
            self.hostname = 'fr' + re.match(r'.*fr(.*)\).*', alerte.lower()).group(1)
        return self.hostname

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
                "Erreur en tentant d'exécuter le processus :\n\n", e.strerror)
        n.show()

    def main(self):
        alerte = self.get_last_alerte()
        if alerte != self.previous_alerte and self.previous_alerte != '':
            print "Alerte : " + alerte
            try:
                self.hostname = self.get_hostname(alerte)
                print "Host : " + self.hostname
            except Exception as e:
                self.show_error_dialog(\
                    "Erreur en tentant de parser le self.hostname :\n\n", e.message)
            n = pynotify.Notification('Alerte', alerte)
            self.notifications.append(n) 
            if self.hostname[11] == 'u' or self.hostname[11] == 'l':
                n.add_action("ssh", "SSH", self.callback)
            if self.hostname[11] == 'w':
                n.add_action("rdp", "RDP", self.callback)
            if self.hostname[9] == 'v':
                n.set_urgency(pynotify.URGENCY_CRITICAL)
            else:
                n.set_urgency(pynotify.URGENCY_NORMAL)
            n.add_action("centreon", "Centreon", self.callback)
            n.add_action("crdi", "CRDI", self.callback)
            n.show()
        self.previous_alerte = alerte
        gobject.timeout_add(10000, self.main)

if __name__ == '__main__':
    Alerte()
