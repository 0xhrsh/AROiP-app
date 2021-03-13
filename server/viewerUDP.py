#!/usr/bin/env python

import socket
import time
import os
import ntplib

class Client:

    def start(self):
        
        # UDP_IP = '127.0.0.1'
        UDP_PORT = 5006
        BUFFER_SIZE = 1024

        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        s.bind(("", UDP_PORT))

        fileName = "latencyViewerTCP{}.txt".format(random.randint(0, 1000))
        f = open(fileName, 'w')
        

        try:
            while True:
                data, addr = s.recvfrom(1024)
                client_time = time.time()
                t = data.split(":")[0]
                print("Difference by:", client_time - float(t))
                line = str(client_time - float(t)) + "\n"
                f.write(line)


        except KeyboardInterrupt:
            f.close()
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
