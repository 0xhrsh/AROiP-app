#!/usr/bin/env python

import socket
import time
import os
import ntplib
import errno
import random


class Client:

    def start(self, num):

        TCP_IP = '192.168.1.69'
        TCP_PORT = 5005
        BUFFER_SIZE = 1024

        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((TCP_IP, TCP_PORT))

        # fileName = "data_tcp/{}/latencyViewerTCP{}.txt".format(num, random.randint(0, 10000))
        fileName = "graph/data_tcp/200/latencyViewer{}.txt".format(random.randint(0, 10000))
        f = open(fileName, 'w')

        i = 0
        try:
            while True:
                newestData = None
                data = b':'
                # while str(i) != data.decode().split(':')[0]:
                #     try:
                #         data = s.recv(1024)
                #         print(data)
                #         if data:
                #             newestData = data
                #     except socket.error as why:
                #         if why.args[0] == errno.EWOULDBLOCK:
                #             break
                #         else:
                #             raise why
                
                data = s.recv(1024)
                if(len(data.split())==1):
                    newestData = data.split()[-1]
                else:
                    newestData = data.split()[-2]

                # print(newestData)
                client_time = time.time()
                try:
                    t = newestData.decode().split(":")[1]
                except:
                    continue
                line = str(client_time - float(t)) + "\n"
                f.write(line)
                # print(client_time - float(t), i)
                
                i+=1
                

        except KeyboardInterrupt:
            f.close()
            s.close()  # On pressing ctrl + c, we close all connections
            quit()  # Then we shut down the server


def run(num):
    # try:
    #     client = ntplib.NTPClient()
    #     response = client.request('in.pool.ntp.org')
    #     os.system('date ' + time.strftime('%m%d%H%M%Y.%S',
    #                                       time.localtime(response.tx_time)))
    # except:
    #     print('Could not sync with time server.')
    client = Client()
    client.start(num)
