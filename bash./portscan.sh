#A simple portscan using bash and hping3

#!/bin/bash

if [ "$1" == "" ]
then
	echo "Insira um argumento para varredura."
	echo "Só será testada uma porta a cada varredura."
	echo "Exemplo: $0 -i 191.168.0 -p 80"
else
	for i in {1..255}
	do
		hping3 -S -p $4 -c 1 $2.$i 2>/dev/null | grep "ip=" | cut -d " " -f2 | cut -d "=" -f2
	done
fi
