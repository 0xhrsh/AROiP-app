import socket
import threading

FORMAT_STRING = "Please give operation in the correct form: num1<space>+<space>num2<space>/<space>num3.\n All other operations are invalid".encode(
    'utf8')


class HTTPServer:

    def __init__(self, host='127.0.0.1', port=8888):
        self.host = host
        self.port = port

    def handle_single_connection(self, conn):
        while True:
            try:
                data = conn.recv(1024)
            except socket.error:
                conn.close()
                break
            if data == b"" or data == b"quit\n":
                conn.close()
                break
            print(data)
            # response = self.handle_request(data)
            conn.sendall(data)

    def start(self):

        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind((self.host, self.port))
        s.listen(5)

        print("Listening at", s.getsockname())

        threads = []

        try:
            while True:
                conn, addr = s.accept()
                print("Connected by", addr)
                t = threading.Thread(
                    target=self.handle_single_connection, args=(conn,), daemon=True)
                t.start()
                threads.append(conn)

        except KeyboardInterrupt:
            s.close()
            for conn in threads:
                conn.close()
            quit()

    def handle_request(self, data):
        return str(1).encode('utf8')
