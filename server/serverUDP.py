from HTTPServer import HTTPServer
import socket
import threading


class Server(HTTPServer):

    def msgSender(self):
        sender = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sender.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sender.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        try:
            while True:
                msg = (yield)
                print("Send message",msg)
                sender.sendto(msg, ('<broadcast>', 5006))
        except GeneratorExit:
            sender.close()

    def start(self):

        # Presenter - 5005
        # Viewer - 5006

        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        s.bind((self.host, 5005))
        # Here we don't close the socket, therefore multiple clients can connect
        print("Listening at", s.getsockname())

        sendData = self.msgSender()

        sendData.__next__()
        

        try:
            while True:
                data, addr = s.recvfrom(1024)
                print("Connected by", addr)
                # threads.append(conn)
                # t = threading.Thread( # we start a thread for each new client
                #     target=self.handle_UDP_connection, args=(data), daemon=True)
                # t.start()
                msg = self.handle_request(data, [])
                sendData.send(msg)

        except KeyboardInterrupt:
            sendData.close()
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
    server = Server()
    server.start()
