#!/usr/bin/env python

import socket
import time
import os
import ntplib
import errno


class Client:

    def start(self):

        TCP_IP = '192.168.1.69'
        TCP_PORT = 5005
        BUFFER_SIZE = 1024
        SLEEP_TIME = 0.2

        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((TCP_IP, TCP_PORT))

        i = 0
        try:
            while True:
                client_time = time.time()
                MESSAGE = str(i) + ":" + str(client_time)
                s.send(MESSAGE.encode("utf8"))
                
                newestData = None
                data = b':'
                while str(i) != data.decode().split(':')[0]:
                    try:
                        data = s.recv(1024)
                        if data:
                            newestData = data
                    except socket.error as why:
                        if why.args[0] == errno.EWOULDBLOCK:
                            break
                        else:
                            raise why
                
                # print(time.time() - client_time, i)
                if(i%100==0):
                    print(i)
                i+=1
                time.sleep(SLEEP_TIME)

        except KeyboardInterrupt:
            s.close()  # On pressing ctrl + c, we close all connections
            quit()  # Then we shut down the server


if __name__ == '__main__':
    try:
        client = ntplib.NTPClient()
        response = client.request('in.pool.ntp.org')
        os.system('date ' + time.strftime('%m%d%H%M%Y.%S',
                                          time.localtime(response.tx_time)))
    except:
        print('Could not sync with time server.')
    client = Client()
    client.start()
