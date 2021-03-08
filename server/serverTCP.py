from HTTPServer import HTTPServer
import socket
import threading


class Server(HTTPServer):

    def start(self):

        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind((self.host, self.port))
        s.listen(100)
        # Here we don't close the socket, therefore multiple clients can connect
        print("Listening at", s.getsockname())

        threads = []

        try:
            while True:
                conn, addr = s.accept()
                print("Connected by", addr) 
                threads.append(conn)
                t = threading.Thread( # we start a thread for each new client
                    target=self.handle_single_connection, args=(conn, threads), daemon=True) 
                t.start()

        except KeyboardInterrupt:
            s.close() # On pressing ctrl + c, we close all connections
            for conn in threads:
                conn.close()
            quit() # Then we shut down the server


if __name__ == '__main__':
    try:
        client = ntplib.NTPClient()
        response = client.request('in.pool.ntp.org')
        os.system('date ' + time.strftime('%m%d%H%M%Y.%S',time.localtime(response.tx_time)))
    except:
        print('Could not sync with time server.')
    server = Server()
    server.start()
