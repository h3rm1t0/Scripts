#This scritps make brute force dns to find subdomains of one target, it will require a wordlist of dns and one target domain. This will only search for domain in the
#follow patern: XXX.tagetdomain.com, where XXX is the word in subdomain wordlist.

#!/bin/bash

banner(){
	local txt="$1"
	local l=100
	local l_txt=${#txt}
	local tot=$((l - l_txt))
	local left=$((tot / 2))
	local right=$((tot - left))
	printf "%*s%s%*s\n" $left "" "$txt" $right "" | tr ' ' '='
}

if [[ $# == 0 || $# -ge 3 ]]; then

	echo "+-+-+-+-+-+ +-+-+-+"
	echo "|B|r|u|t|e| |D|N|S|"
	echo "+-+-+-+-+-+ +-+-+-+"

	echo "Insira um argumento válido para realizar o brute force."
	echo "Ex.: ./$0 <caminho absoluto da wordlist> <domínio alvo>"
	exit
else

        echo "+-+-+-+-+-+ +-+-+-+"
        echo "|B|r|u|t|e| |D|N|S|"
        echo "+-+-+-+-+-+ +-+-+-+"

	n=1
	rm bruteforce_log.txt 2> /dev/null
	for line in $(cat $1); do
		banner "[$n] $line" | tee -a bruteforce_log.txt
		host -t a $line.$2 | tee -a bruteforce_log.txt
		echo ""
		n=$((n+1))
	done

fi
