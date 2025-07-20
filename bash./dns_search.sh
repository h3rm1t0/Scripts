#The idea of this script is to make a dns search in one target domain, it realize querys for text information for domain servers, start of authority, IPv4, IPv6,
#e-mails servers and host information. It also try a zone transfer against each name server founded.

#!/bin/bash

banner() {
	local txt="$1"
	local l=100
	local l_txt=${#txt}
	local tot=$((l - l_txt))
	local left=$((tot / 2))
	local right=$((tot - left))
	printf "%*s%s%*s\n" $left "" "$txt" $right "" | tr ' ' ':'
}


if [[ $# == 0 || $# -ge 2 ]]; then
	echo " ____  _   _ ____    ____  _____    _    ____   ____ _   _ "
	echo "|  _ \| \ | / ___|  / ___|| ____|  / \  |  _ \ / ___| | | |"
	echo "| | | |  \| \___ \  \___ \|  _|   / _ \ | |_) | |   | |_| |"
	echo "| |_| | |\  |___) |  ___) | |___ / ___ \|  _ <| |___|  _  |"
	echo "|____/|_| \_|____/  |____/|_____/_/   \_\_| \_\\_____|_| |_|"

	echo "Insira um domínio como argumento para realizar a pesquisa DNS."
	echo "Ex.: ./dns_search <domínio alvo>"
	exit
else

        echo " ____  _   _ ____    ____  _____    _    ____   ____ _   _ "
        echo "|  _ \| \ | / ___|  / ___|| ____|  / \  |  _ \ / ___| | | |"
        echo "| | | |  \| \___ \  \___ \|  _|   / _ \ | |_) | |   | |_| |"
        echo "| |_| | |\  |___) |  ___) | |___ / ___ \|  _ <| |___|  _  |"
        echo "|____/|_| \_|____/  |____/|_____/_/   \_\_| \_\\_____|_| |_|"

	rm log.txt 2> /dev/null
	echo "[INFO] Todo stdout será direcionado ao arquivo log.txt neste diretório..."
	echo "[INFO] Iniciando querys dns padrão..."
	echo ""

	banner "Responsável pelo Domínio" | tee -a log.txt
	host -t soa $1 | tee -a log.txt
	echo ""

	banner "Name Servers"  | tee -a log.txt
	host -t ns $1 | tee -a log.txt
	echo ""

	banner "IPv4" | tee -a log.txt
	host -t a $1 | tee -a log.txt
	echo ""

	banner "IPv6" | tee -a log.txt
	host -t aaaa $1 | tee -a log.txt
	echo ""

	banner "Servidor de e-mail" | tee -a log.txt
	host -t mx $1 | tee -a log.txt
	echo ""

	banner "Informações do Host" | tee -a log.txt
	host -t hinfo $1 | tee -a log.txt
	echo ""

	banner "Registros de Texto" | tee -a log.txt
	host -t txt $1 | tee -a log.txt
	banner ""
	echo ""

	echo "[INFO] Iniciando tentativa de transferência de zona nos name servers encontrados..."
	host -t ns $1 | cut -d " " -f4 > dns_list.txt
	for line in $(cat dns_list.txt); do
	banner "Name Server : $line" | tee -a log.txt
	host -l $1 $line 2>&1 | tee -a log.txt
	echo ""
	done
	banner ""
	rm dns_list.txt 2> /dev/null
fi

