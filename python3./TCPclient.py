#A basic tcp client that can be utilized like a chat, this is script is maded to study how work with with tcp and understand how work sending and recieving data on sockets.

#!/bin/python3

import socket                                                     
import sys                                                        

target_host = '0.0.0.0'                                             #IP ou domínio alvo
target_port = 9998                                                  #Porta alvo

client = socket.socket(socket.AF_INET,socket.SOCK_STREAM)           #Criação do objeto socket com família AF_INET e para trabalhar com TCP em SOCK_STREAM

client.connect((target_host,target_port))                           #Envio de tentativa de conexão a porta e domínio/IP alvo

while True:
    request = input("[ENTRADA]Escreva a mensagem a ser enviada: ") 

    if request == 'Tchau':                                          #Se o pacote enviado conter a string 'Tchau' então é iniciada a sequência de encerramento de conexão
        client.send(request.encode("utf-8"))                        #Envia o pacote final simbolizando o final da conexão
        print('[DEBBUG] Conexão sendo encerrada...')                
        client.close()                                              #Encerra o objeto socket do client
        exit()                                                      #Sai do loop infinito

    client.send(request.encode())                                   #Envio e uma requisição para o domínio/IP alvo, por se tratar de um serviço de servidor web
                                                                    #então iremos realizar uma requisição HTTP ao servidor
    response = client.recv(4096)                                    #Recebe a resposta do servidor com tamanho máximo de 4096 bytes
    print(f'[SAÍDA]: {response.decode()}')                          #Decodifica a resposta em UTF-8 utilizando o método decode() e exibe na tela
