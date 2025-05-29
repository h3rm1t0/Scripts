#Script maded to understand how make a simple TCP server. This server handle requests and send messages through socket.

#!/bin/python3

import socket
import threading                                                                            #Threading permite que o programa execute multiplas tarefas simultaneamente

IP = '0.0.0.0'                                                                              #IP do servidor
PORT = 9998                                                                                 #Porta do servidor

def main():
    server = socket.socket(socket.AF_INET,socket.SOCK_STREAM)                               #Criando objeto socket para conexão TCP
    server.bind((IP,PORT))                                                                  #Vincula o conjunto (IP,PORT) ao objeto socket criado
    server.listen(5)                                                                        #Coloca o servidor para escutar (aguardar conexõe)
    print(f'[DEBBUG] Escutando {IP}:{PORT}')

    while True:                                                                             #Loop infinito iniciado para receber requisições e trata-las
        client, address =  server.accept()                                                  #Interrompe a execução do programa até estabelecer uma conexão de entrada com o client
        print(f'[DEBBUG] Conexão aceita de {address[0]}:{address[1]}')
        client_handler = threading.Thread(target=handle_client,args=(client,))              #Define a thread que irá processar as requisições do client
        client_handler.start()                                                              #Inicia a thread criada anteriormente com o client

def handle_client(client_socket):
    with client_socket as sock:                                                             #Trata o socket_client como sock
        while True:
            request = sock.recv(1024)                                                       #Recebe a requisição do client de até 1024 bytes e armazena em request
            if request.decode() == 'Tchau':
                print(f'[!!!ATENÇÃO!!!] Mensagem de encerramento [{request.decode()}] de conexão por parte do client')
                print(f'[DEBBUG] Encerrando conexão com {client_socket} ...')
                break
                                                                   
            print(f'[ENTRADA] PACOTE RECEBIDO {request.decode("utf-8")}')                   #Decodifica a requisição do client e printa na tela
            response = input(f"[SAÍDA] {client_socket}: ")               #Aguarda input de resposta para o client_socket
            sock.send(response.encode("utf-8"))                                             #Codifica a mensagem fornecida e envia ao client           

if __name__== '__main__':
    main()
