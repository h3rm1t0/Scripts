# A simple UDP server that recieve messages from a unique client
#!/bin/python3

import socket

IP = "0.0.0.0"
PORT = 8080

def main():
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((IP,PORT))
    print(f"[DEBBUG] Escutando em {IP}:{PORT}")
  
    while True:  
        data, addr = sock.recvfrom(4064)
        print(f"[ENTRADA] Mensagem: {data.decode()}")

if __name__ == '__main__':
    main()
