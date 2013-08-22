#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import re
import subprocess
import socket
import ConfigParser
import xdg.BaseDirectory as bd
import pynotify
import gtk

from checkalerte import CheckAlerte

class Alerte:

    def __init__(self):
        pynotify.init('Alertes')
        self.config = ConfigParser.ConfigParser()
        self.previous_alerte = ''
        self.hostname = ''
        self.alerte = ''
        self.notifications = []
        self.ca = CheckAlerte(self)
        self.ca.start()
        try: pole = self.config.get('Alertes', 'pole')
        except: pole = "all"
        self.ca.pole = pole
        # make sure threads are not locked by gtk main loop
        try:
            gtk.gdk.threads_init()
        except: pass
        gtk.main()

    def get_hostname(self):
        try:
            hostname = re.match(r'.*((f[r,1-9]|ro|sd)[d,m,i][0-9]{3}[p,d,t,s,e,b][0-9]{2,3}[a-z]{2}[u,w,l,o,a,n]).*',
                                self.alerte.lower()).group(1)
        except (IndexError, AttributeError), e:
            print "Incapable d'identifier le nom de la machine :\n\n" + e.message
            hostname = ''
        return hostname

    def get_error_dialog(self, primarytext, secondarytext):
        error_dialog = gtk.MessageDialog(None,
                gtk.DIALOG_DESTROY_WITH_PARENT, gtk.MESSAGE_ERROR,
                gtk.BUTTONS_CLOSE, primarytext)
        error_dialog.format_secondary_text(secondarytext)
        error_dialog.set_keep_above(True)
        return error_dialog

    def add_button(self, action, error_dialog):
        button = gtk.Button(action, stock=None)
        button.connect("clicked", self.callback, action)
        error_dialog.action_area.add(button)
        button.show()

    def callback(self, n, action):
        if action == 'SSH':
            try : terminal = self.config.get('Applications', 'terminal')
            except KeyError: terminal = '/usr/bin/gnome-terminal'
            process = [terminal, '-e', 'ssh '
                       + self.hostname]
        elif action == 'RDP':
            process = ['/usr/bin/rdesktop', self.hostname]
        elif action == 'DRAC':
            process = ['/usr/bin/xdg-open',
                       "http://%s.drac.integra.fr/" % self.hostname]
        elif action == 'Centreon':
            process = ['/usr/bin/xdg-open',
                       'https://centreon.itc.integra.fr/main.php?p=20201&o=svc&host_search='
                        + self.hostname]
        elif action == 'CRDI':
            process = ['/usr/bin/xdg-open',
                       'https://intranet.itc.integra.fr/crdi/']
        elif action == 'Resolv':
            process = ['/usr/bin/xdg-open',
                       'http://resolv.itc.integra.fr/?quoi='
                       + self.hostname]
        try:
            subprocess.Popen(process)
        except OSError, e:
            print "Erreur en tentant d'exécuter le processus :\n\n" + e.strerror
        n.show()

    def show_alerte_notification(self):
        n = pynotify.Notification('Alerte sur ' + self.hostname,
                                  self.alerte, 'abrt')
        self.notifications.append(n)
        if self.hostname[-1] == 'u' or self.hostname[-1] == 'l' \
            or self.hostname[-3:] == 'san':
            n.add_action('SSH', 'SSH', self.callback)
        if self.hostname[-1] == 'w':
            n.add_action('RDP', 'RDP', self.callback)
        if self.hostname[6] == 'p':
            n.set_urgency(pynotify.URGENCY_CRITICAL)
        else:
            n.set_urgency(pynotify.URGENCY_NORMAL)
        try :
            socket.getaddrinfo(self.hostname + '.drac.integra.fr', '80')
            n.add_action('DRAC', 'DRAC', self.callback)
        except: pass
        n.add_action('Centreon', 'Centreon', self.callback)
        n.show()

    def show_alerte_dialog(self):
        error_dialog = self.get_error_dialog("Alerte sur " + self.hostname,
                                             self.alerte)
        if self.hostname[-1] == 'u' or self.hostname[-1] == 'l' \
            or self.hostname[-3:] == 'san':
            self.add_button("SSH", error_dialog)
        if self.hostname[-1] == 'w':
            self.add_button("RDP", error_dialog)
        try :
            socket.getaddrinfo(self.hostname + '.drac.integra.fr', '80')
            self.add_button("DRAC", error_dialog)
        except: pass
        self.add_button("Centreon", error_dialog)
        self.add_button("CRDI", error_dialog)
        self.add_button("Resolv", error_dialog)
        if error_dialog.run() == gtk.RESPONSE_CLOSE: error_dialog.destroy()

    def show_alerte(self, alerte):
        self.alerte = alerte
        self.hostname = self.get_hostname()
        self.config.read(bd.load_first_config('alerte.conf'))
        try : show_notifications = self.config.get('Alertes', 'show_notifications')
        except KeyError: show_notifications = "on"
        try : show_dialogs = self.config.get('Alertes', 'show_dialogs')
        except KeyError: show_dialogs = "off"
        if show_notifications == "on" : self.show_alerte_notification()
        if show_dialogs == "on" : self.show_alerte_dialog()
        print 'Host : ' + self.hostname
        print 'Alerte : ' + self.alerte

if __name__ == '__main__':
    Alerte()
