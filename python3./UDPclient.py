#A simple UDP client that send messages to UDP server
#! /bin/python3

import socket

target_ip = '127.0.0.1'
target_port = 8080

def main():
    client = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)

    while True:        
        msg = input("[ENVIAR] : ")
        client.sendto(msg.encode(), ((target_ip,target_port)))
            
if __name__ == '__main__':
    main()
