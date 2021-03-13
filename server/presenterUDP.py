#!/usr/bin/env python

import socket
import time
import os
import ntplib

class Client:

    def start(self):
        
        UDP_IP = '127.0.0.1'
        UDP_PORT = 5005
        BUFFER_SIZE = 1024
        SLEEP_TIME = 5

        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEPORT, 1)

        try:
            while True:
                client_time = time.time()
                MESSAGE = "" + str(client_time) + ":" + "Data"
                s.sendto(MESSAGE.encode("utf8"),(UDP_IP, UDP_PORT))
                # data = s.recv(1024)
                # t = data.split(":")[0]
                # print("Difference by:", float(t)-client_time)
                time.sleep(SLEEP_TIME)

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
