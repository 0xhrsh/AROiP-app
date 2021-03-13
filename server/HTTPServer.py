import socket
import time
from HTTPRequest import HTTPRequest

FORMAT_STRING = "Please give operation in the correct form. Example: 1 <space> + <space> 2".encode('utf8')


class HTTPServer:

    def __init__(self, host='192.168.1.69', port=5005):
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

    def start(self):
        # To be defined in server files
        return

    def handle_request(self, data, threads):

        request = HTTPRequest(data)

        client_time = request.method.split(":")[0] # We assume the operands will be space seperated

        server_time = time.time()
        MESSAGE = "" + str(server_time) + ":" +request.method.split(":")[0] + ":" +request.method.split(":")[1]

        return MESSAGE.encode('utf8')
