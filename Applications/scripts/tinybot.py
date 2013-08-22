#!/usr/bin/env python3

import logging, sh, re, pickle

from sleekxmpp import ClientXMPP
from sleekxmpp.exceptions import IqError, IqTimeout

from checkalerte import CheckAlerte


class TinyBot(ClientXMPP):

    def __init__(self, jid, password):
        ClientXMPP.__init__(self, jid, password)

        self.add_event_handler("session_start", self.session_start)
        self.add_event_handler("message", self.message)

        self.alertes_jids = []
        self.alertes_type = {}
        self.read_conf()
        ca = CheckAlerte(self)
        ca.start()

    def session_start(self, event):
        self.send_presence()
        self.get_roster()

        # Most get_*/set_* methods from plugins use Iq stanzas, which
        # can generate IqError and IqTimeout exceptions
        #
        # try:
        #     self.get_roster()
        # except IqError as err:
        #     logging.error('There was an error getting the roster')
        #     logging.error(err.iq['error']['condition'])
        #     self.disconnect()
        # except IqTimeout:
        #     logging.error('Server is taking too long to respond')
        #     self.disconnect()

    def message(self, msg):
        if msg['type'] in ('chat', 'normal'):
            command = msg['body']
            jid = str(msg.getFrom())
            if re.match('resolv.*', command):
                server = re.match('resolv (.*)', command).group(1)
                result = sh.grep(sh.wget('http://resolv.itc.integra.fr/?quoi=%s' % server, '-O', '-'), '-vE', '<|{|}|;|\($')
                msg.reply(result).send()
            elif command == "alertes enabled on":
                if jid not in self.alertes_jids:
                    self.alertes_jids.append(jid)
                    self.save_conf()
                msg.reply("Alertes activées pour %s" % jid).send()
            elif command == "alertes enabled off":
                if jid in self.alertes_jids:
                    self.alertes_jids.remove(jid)
                    self.save_conf()
                msg.reply("Alertes désactivées pour %s" % jid).send()
            elif re.match('alertes type (all|unix|windows|network)', command):
                type = re.match('alertes type (.*)', command).group(1)
                self.alertes_type[jid] = type
                self.save_conf()
                msg.reply("Type des alertes définit à %s pour %s" % (type, jid)).send()
            elif command == "help":
                msg.reply(
                """Les commandes disponibles sont :
                help -- affiche ce message
                resolv <hostname> -- effectue un resolv sur le hostname
                alertes enabled <on|off> -- active/désactive les alertes d'incident
                alertes type <all|unix|windows|network> -- sélectionne le type d'alertes à afficher"""
                ).send()
            else:
                msg.reply(
                """%s : Instruction inconnue. Veuillez reformuler.
                Taper 'help' pour avoir la liste des commandes disponibles."""
                % command).send()

    def show_alerte(self, alerte):
        for jid in self.alertes_jids:
            self.send_message(mto=jid,
                              mbody=alerte,
                              mtype='chat')

    def save_conf(self):
        try:
            f = open('alertes_jids.pickle', 'wb')
            pickle.dump(self.alertes_jids, f)
        except OSError as err:
             logging.error(err.iq['error']['condition'])
        try:
            f = open('alertes_type.pickle', 'wb')
            pickle.dump(self.alertes_type, f)
        except OSError as err:
             logging.error(err.iq['error']['condition'])

    def read_conf(self):
        try:
            f = open('alertes_jids.pickle', 'rb')
            self.alertes_jids = pickle.load(f)
        except OSError as err:
             logging.error(err.iq['error']['condition'])
        try:
            f = open('alertes_type.pickle', 'rb')
            self.alertes_type = pickle.load(f)
        except OSError as err:
             logging.error(err.iq['error']['condition'])

if __name__ == '__main__':
    logging.basicConfig(level=logging.ERROR,
                        format='%(levelname)-8s %(message)s')

    xmpp = TinyBot('tinybot@integra.fr', 'f8eixpRS6')
    xmpp.connect()
    xmpp.process(block=True)
