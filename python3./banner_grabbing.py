#Script that i had made to solve one laboratory. It can scan one list of IPs to make banner grabbing in a specific port.

#!/bin/python3

import socket
import sys


if ((len(sys.argv) - 1) < 1):

        print ('[ATENÇÃO]: O script exige duas entradas.')
        print ('[FUNÇÃO]: Realiza banner grabbing em uma lista de IP em uma porta de interesse.')
        print (f'[EXEMPLO]: ./interact.py <porta> <Caminho absoluto de uma lista de IPs>')

else:

        ip_list =  sys.argv[2]
        p = int(sys.argv[1])

        with open(ip_list, 'r') as file:
                for line in file:

                        ip = line.strip()
                        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

                        print (f'++++ BANNER GRABBING {ip}:{p} ++++')

                        if sock.connect_ex((ip,p)) == 0:
                                banner = sock.recv(1024)
                                print (banner)
                                msg = 'AAA'
                                sock.send(str.encode(msg))
                                banner = sock.recv(1024)
                                print (banner)
                                msg = 'BBB'
                                sock.send(str.encode(msg))
                                banner = sock.recv(1024)
                                print (banner)
                                sock.close()
                        else:
                                print ('SERVIÇO INDISPONÍVEL OU CONEXÃO NEGADA')
                                sock.close()


