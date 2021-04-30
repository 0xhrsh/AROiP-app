from HTTPServer import HTTPServer
import socket
import threading
import ntplib
import time
import os


class Server(HTTPServer):

    def msgSender(self):
        sender = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sender.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sender.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        try:
            while True:
                msg = (yield)
                # print("Send message",msg)
                sender.sendto(msg, ('<broadcast>', 5006))
        except GeneratorExit:
            sender.close()

    def start(self):

        self.s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        self.s.bind((self.host, self.port))

        # Here we don't close the socket, therefore multiple clients can connect
        print("Listening at", self.s.getsockname())

        # sendData = self.msgSender()

        # sendData.__next__()
        
        threads = []

        try:
            while True:
                data, addr = self.s.recvfrom(1024)
                print("Connected by", addr, " | Data", data)
                threads.append(addr)
                t = threading.Thread( # we start a thread for each new client
                    target=self.handle_UDP_connection, args=(data, addr, threads), daemon=True)
                t.start()
                # msg = self.handle_request(data, [])
                # sendData.send(msg)

        except KeyboardInterrupt:
            # sendData.close()
            self.s.close()  # On pressing ctrl + c, we close all connections
            quit()  # Then we shut down the server


if __name__ == '__main__':
    try:
        client = ntplib.NTPClient()
        response = client.request('in.pool.ntp.org')
        os.system('date ' + time.strftime('%m%d%H%M%Y.%S',
                                          time.localtime(response.tx_time)))
    except:
        print('Could not sync with time server.')
    server = Server()
    server.start()
