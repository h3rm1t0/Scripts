#The ideia of this script is use one subdomain list to extract information via http requests, it will try to clone all index pages of each subdomain on the list.
#It also try to catch information about the tecnology used in website, server and all methods allowed for each subdomain, all this information will be stored
#in extractor directory and extractor_log.txt inside of this directory.

#!/bin/bash

banner(){
	local txt="$1"
	local l_tot=70
	local l_txt=${#txt}
	local l=$((l_tot - l_txt))
	local left=$((l / 2))
	local right=$((l - left))
	printf "%*s%s%*s\n"  $left "" "$txt" $right "" | tr ' ' '+'
}

if [[ $# -eq 0 || $# -ge 3 ]];then

	echo -e "\033[5;33m"
        echo '------------------------------------------------------------------'
        echo '   __ _________________    ____     __               __          '
        echo '  / // /_  __/_  __/ _ \  / __/_ __/ /________ _____/ /____  ____'
        echo ' / _  / / /   / / / ___/ / _/ \ \ / __/ __/ _ `/ __/ __/ _ \/ __/'
        echo '/_//_/ /_/   /_/ /_/    /___//_\_\\__/_/  \_,_/\__/\__/\___/_/   '
        echo '-----------------------------------------------------------------'
        echo -e "\033[0m"

	echo ""
	echo "Insert a absolut path to a list of subdomains of one target and the target domain to use this scritp."
	echo "Ex.: $0 <absolut path> <domain>"
	echo "Ex.: $0 /usr/share/wordlists/wordlist.txt targetdomain.com.br"
	exit
else
    	echo -e "\033[5;33m"
	echo '------------------------------------------------------------------'
        echo '   __ _________________    ____     __               __          '
        echo '  / // /_  __/_  __/ _ \  / __/_ __/ /________ _____/ /____  ____'
        echo ' / _  / / /   / / / ___/ / _/ \ \ / __/ __/ _ `/ __/ __/ _ \/ __/'
        echo '/_//_/ /_/   /_/ /_/    /___//_\_\\__/_/  \_,_/\__/\__/\___/_/   '
	echo '-----------------------------------------------------------------'
	echo -e "\033[0m"
	echo ""
	path=$1
	domain=$2
	i=1
	rm -rf "extractor" 2> /dev/null
        mkdir "extractor"
	cd "extractor"
	mkdir "$domain"
	cd "$domain"
	for line in $(cat $path);do
		response=$({
		    echo -e "OPTIONS / HTTP/1.0\r\nHost: $domain\r\n\r\n"
		} | nc -w 3 "$line" 80 2>/dev/null
		)
                response2=$({
                echo -e "HEAD / HTTP/1.0\r\n\Host: $domain\r\n\r\n"
                } | nc -w 3 "$line" 80 2>/dev/null)

		if [[ -n "$response" || -n "$response2" ]];then
			banner "[$i]Domain:$line" | tee -a "extractor_log.txt"
			echo -e "$response" | grep -Ei "Allow" | while read -r line; do
				echo -e "\033[32m$line\033[0m" | tee -a "extractor_log.txt"
			done
			echo "$response2" | grep -Ei "Server:" | while read -r line;do
				echo -e "\033[33m$line\033[0m" | tee -a "extractor_log.txt"
			done
                	echo "$response2" | grep -Ei "X-Powered-By:" | while read -r line;do
				echo -e "\033[31m$line\033[0m" | tee -a "extractor_log.txt"
			done
		echo "Cloning the page in $domain on current directory..."
		echo -e "\033[5;37mDownloading $line...\033[0m"
		wget -m -e robots=off $line --quiet > /dev/null 2>&1 | tee -a "extractor_log.txt"
		fi
		i=$(($i + 1))
		echo ""
	done
fi

