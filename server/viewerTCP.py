#!/usr/bin/env python

import socket
import time
import os
import ntplib

class Client:

    def start(self):
        
        TCP_IP = '127.0.0.1'
        TCP_PORT = 5005
        BUFFER_SIZE = 1024

        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((TCP_IP, TCP_PORT))

        try:
            while True:
                data = s.recv(1024)
                client_time = time.time()
                t = data.split(":")[1]
                print("Difference by:", client_time - float(t))


        except KeyboardInterrupt:
            s.close() # On pressing ctrl + c, we close all connections
            quit() # Then we shut down the server


if __name__ == '__main__':
    try:
        client = ntplib.NTPClient()
        response = client.request('in.pool.ntp.org')
        os.system('date ' + time.strftime('%m%d%H%M%Y.%S',time.localtime(response.tx_time)))
    except:
        print('Could not sync with time server.')
    client = Client()
    client.start()
