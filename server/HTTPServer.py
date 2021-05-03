import socket
import time
from HTTPRequest import HTTPRequest

FORMAT_STRING = "Please give operation in the correct form. Example: 1 <space> + <space> 2".encode('utf8')


class HTTPServer:

    def __init__(self, host='127.0.0.1', port=5005):
        self.host = host
        self.port = port

    def handle_single_connection(self, conn, threads):
        while True:
            try:
                data = conn.recv(1024)
            except socket.error:
                conn.close()
                threads.remove(conn)
                break
            if data == b"" or data == b"quit\n":
                conn.close() # Client disconnects at typing "quit" or pressing ctrl + c
                threads.remove(conn)
                break
            response = self.handle_request(data, threads) # here we calculate the operation
            # conn.sendall(response)
            for con in threads:
                con.sendall(response)

    def handle_UDP_connection(self, data, addr, threads):
            if data == b"init":
                return # Save Adr in thread 
            if data == b"" or data == b"quit\n":
                # Client disconnects at typing "quit" or pressing ctrl + c
                threads.remove(addr)
                return
            else:
                response = self.handle_request(data, threads) # here we calculate the operation
                # conn.sendall(response)
                for addr in threads:
                    print("Sending Data to:", addr)
                    self.s.sendto(response,addr)
                return

    def start(self):
        # To be defined in server files
        return

    def handle_request(self, data, threads):

        request = HTTPRequest(data)

        MESSAGE = request.method + ":" + str(time.time())

        return MESSAGE.encode('utf8')
