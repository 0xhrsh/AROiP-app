#!/usr/bin/env python

import socket
import time
import os
import ntplib
import random


class Client:

    def start(self):

        TCP_IP = '192.168.1.69'
        TCP_PORT = 5005
        BUFFER_SIZE = 1024

        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((TCP_IP, TCP_PORT))

        fileName = "data_tcp/50/latencyViewerTCP{}.txt".format(random.randint(0, 10000))
        f = open(fileName, 'w')

        try:
            while True:
                data = s.recv(1024).decode('utf8')
                client_time = time.time()
                t = data.split(":")[1]
                line = str(client_time - float(t)) + "\n"
                f.write(line)
                # print(line)

        except KeyboardInterrupt:
            s.close()  # On pressing ctrl + c, we close all connections
            quit()  # Then we shut down the server


def run():
    # try:
    #     client = ntplib.NTPClient()
    #     response = client.request('in.pool.ntp.org')
    #     os.system('date ' + time.strftime('%m%d%H%M%Y.%S',
    #                                       time.localtime(response.tx_time)))
    # except:
    #     print('Could not sync with time server.')
    client = Client()
    client.start()
