#!/usr/bin/env python

import socket
import time
import errno
import os
import ntplib
import random

class Client:

    UDP_IP = '192.168.1.69'
    UDP_SEND_PORT = 5005
    BUFFER_SIZE = 1024

    def start(self, num):
        print("Started")
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        msg = b"init"
        s.sendto(msg, (self.UDP_IP, self.UDP_SEND_PORT))

        # fileName = "data_udp/{}/latencyViewerUDP{}.txt".format(num, random.randint(0, 10000))
        fileName = "graph/data_udp/200/latencyViewer{}.txt".format(random.randint(0, 10000))
        f = open(fileName, 'w')
        i = 0
        try:
            while True:
                newestData = None
                data = b''

                while str(i) != data.decode().split(':')[0]:
                    try:
                        data, fromAddr = s.recvfrom(1024)
                        if data:
                            newestData = data
                    except socket.error as why:
                        if why.args[0] == errno.EWOULDBLOCK:
                            break
                        else:
                            raise why

                
                client_time = time.time()
                data = data.decode('utf8')
                t = data.split(":")[1]
                #print("Difference by:", client_time - float(t), i)
                line = str(client_time - float(t)) + "\n"
                f.write(line)
                i += 1


        except KeyboardInterrupt:
            f.close()
            s.close() # On pressing ctrl + c, we close all connections
            quit() # Then we shut down the server


def run(num):
# def run():
    # try:
    #     client = ntplib.NTPClient()
    #     response = client.request('in.pool.ntp.org')
    #     os.system('date ' + time.strftime('%m%d%H%M%Y.%S',time.localtime(response.tx_time)))
    # except:
    #     print('Could not sync with time server.')
    client = Client()
    client.start(num)
