#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import re
import subprocess
import urllib2 as u
import pynotify
import gobject
import gtk


class Alerte:

    def __init__(self):
        pynotify.init('Alertes')
        self.previous_alerte = ''
        self.hostname = ''
        self.alerte = ''
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

    def get_hostname(self):
        try:
            hostname = re.match(r'.*([f,s,r][r,o,d,0-9][d,m,i][0-9]{3}[p,d,t,s,e,b][0-9]{2,3}[a-z]{2}[u,w,l,o,a,n]).*',
                                self.alerte.lower()).group(1)
        except (IndexError, AttributeError) as e:
            self.show_error_dialog("Incapable d'identifier le nom de la machine :\n\n",
                                   e.message)
            hostname = 'Machine non identifiée'
        return hostname

    def show_error_dialog(self, primarytext, secondarytext):
        error_dialog = gtk.MessageDialog(None,
                gtk.DIALOG_DESTROY_WITH_PARENT, gtk.MESSAGE_ERROR,
                gtk.BUTTONS_CLOSE, primarytext)
        error_dialog.format_secondary_text(secondarytext)
        response = error_dialog.run()
        if response == gtk.RESPONSE_CLOSE:
            error_dialog.destroy()

    def callback(self, n, action):
        if action == 'ssh':
            process = ['/usr/bin/gnome-terminal', '-e', 'ssh '
                       + self.hostname]
        elif action == 'rdp':
            process = ['/usr/bin/rdesktop', self.hostname]
        elif action == 'centreon':
            process = ['/usr/bin/xdg-open',
                       'https://centreon.itc.integra.fr/main.php?p=20201&o=svc&host_search='
                        + self.hostname]
        elif action == 'crdi':
            process = ['/usr/bin/xdg-open',
                       'https://intranet.itc.integra.fr/crdi/']
        try:
            subprocess.Popen(process)
        except OSError as e:
            self.show_error_dialog("Erreur en tentant d'exécuter le processus :\n\n",
                                   e.strerror)
        n.show()

    def show_alerte(self):
        self.hostname = self.get_hostname()
        n = pynotify.Notification('Alerte sur ' + self.hostname,
                                  self.alerte, 'abrt')
        self.notifications.append(n)
        if self.hostname[-1] == 'u' or self.hostname[-1] == 'l' \
            or self.hostname[-3:] == 'san':
            n.add_action('ssh', 'SSH', self.callback)
        if self.hostname[-1] == 'w':
            n.add_action('rdp', 'RDP', self.callback)
        if self.hostname[6] == 'p':
            n.set_urgency(pynotify.URGENCY_NORMAL)
        else:
            # n.set_urgency(pynotify.URGENCY_CRITICAL)
            n.set_urgency(pynotify.URGENCY_NORMAL)
        n.add_action('centreon', 'Centreon', self.callback)
        n.add_action('crdi', 'CRDI', self.callback)
        print 'Host : ' + self.hostname
        print 'Alerte : ' + self.alerte
        n.show()

    def main(self):
        self.alerte = self.get_last_alerte()
        if self.alerte != self.previous_alerte and \
            self.previous_alerte != '':
            self.show_alerte()
        self.previous_alerte = self.alerte
        gobject.timeout_add(10000, self.main)

if __name__ == '__main__':
    Alerte()
