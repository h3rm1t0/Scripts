#This is a upgraded version of the first portscan, it is more stealth and focus on most commom ports used for a variety of services. Another feature is that this
#portscan has a timeout for each tentative of connection to make it more faster then last version. The last upgrade is it use /dev/tcp to create the connection.

#!/bin/bash

topport=(20 21 22 23 25 53 67 68 69 80 110 111 123 135 137 138 139 143 161 162 179 389 443 445 465 514 587 631 993 995 1433 1434 1521 2049 3306 3389 3690 5432 5900 5985 5986 6379 8000 8080 8443 9001)

if [ "$1" == "" ]
then
	echo "Insira no primeiro argumento um IP para rodar o script."
	echo "Ex.: $0 192.168.0.1"
else
	for n in ${topport[@]}
	do

	timeout 1 bash -c "echo >/dev/tcp/$1/$n" 2> /dev/null

	if [ $? = 0 ]
	then
		echo "[PORTA ABERTA] : $n"
	fi
	done
fi
