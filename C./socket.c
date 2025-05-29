//Script maded to undestand how work with sockets in C, in this case it can verify if one specified port in one IP is open or not.

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>       // Para close()
#include <arpa/inet.h>    // Para inet_addr()
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>

int main(int argc, char *argv[]){
	int sock, conecta, target_port;
	char *target_ip;

	if(argc<3){
	printf("O script socket precisa de 3 argumentos para funcionar.\n");
	printf("Exemplo: ./socket <IP ALVO> <PORTA ALVO>");
	exit(0);
	}

	target_ip = argv[1];
	target_port = atoi(argv[2]);

	struct sockaddr_in alvo;   /*Struct de implementação vinda do manual*/

	sock = socket(AF_INET, SOCK_STREAM, 0); /* AF_INET se refere a utilização de IPv4 e SOCK_STREM indica que irá
					        ser utilizado TCP e por final o protocolo utilizado. Utilizando */
					        /* man ip no terminal é possívl ver qual o código de cada protocolo */

	alvo.sin_family = AF_INET;				/*Construção da família utilizada*/
	alvo.sin_port = htons(target_port);				/*Definição da porta de comunicação do alvo*/
	alvo.sin_addr.s_addr = inet_addr(target_ip);		/*Endereço que será o alvo*/


	conecta = connect(sock, (struct sockaddr *)&alvo,sizeof(alvo)); /*Comando de estabelecimento da conexão*/

	if(conecta == 0){				/*Condição para verificar se há conexão ou não*/
		printf("Porta aberta! \n");
		close(sock);				/*Fechando o objeto socket criado para comunicação com o alvo*/
		close(conecta);				/*Fechando o objeto criado para conexão, o pipe*/
	} else {
		printf("Porta fechada! \n");
	}
}
