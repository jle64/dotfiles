import threading, sh, time

class CheckAlerte(threading.Thread):

    def __init__(self, client):
        threading.Thread.__init__(self)
        self.client = client
        self.previous_alerte = ''
        self.alerte = ''
        self.notifications = []
        self.pole = ''

    def run(self):
        while True:
            if self.pole == 'unix':
                url = 'https://centreon.itc.integra.fr/last/lastPage-U.txt'
            elif self.pole == "win":
                url = 'https://centreon.itc.integra.fr/last/lastPage-W.txt'
            elif self.pole == "infra":
                url = 'https://centreon.itc.integra.fr/last/lastPage-N.txt'
            else:
                url = 'https://centreon.itc.integra.fr/last/lastPage.txt'
            self.alerte = str(sh.wget(url, '-O', '-', '--no-check-certificate', '--no-proxy'))
            if self.alerte != self.previous_alerte and \
                self.previous_alerte != '':
                self.client.show_alerte(self.alerte)
            self.previous_alerte = self.alerte
            time.sleep(1)
