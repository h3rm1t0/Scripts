#This is a simple example of html parsing. It can be used to get a additional information about one domain and other pages related in it. After parsing it will try to
#obtain the IPs from all pages related to the page that you are parsing.

#!/bin/bash

if [ "$1" == "" ]
then
	echo " ====================== Instrução de uso ====================== "
	echo " Insira um site para realizar a análise do html dele."
	echo ""
	echo " Exemplo: html_parsing site_de_interesse"
	echo " ============================================================== "
else
      # wget  $1 2> /dev/null # Outra maneira mais rápida porém menos limpa
	
	echo ""
	echo " +++++++++++++ Realizando requisição do HTML +++++++++++++  "
	echo " +++++++++++++ e salvando no diretório atual +++++++++++++  "
	echo ""
	curl -L $1 > index.html 2> /dev/null
	echo ""

	echo " ========================================================== "
	echo " ================= Aplicando parsing... =================== "
	echo " ========================================================== "
	echo ""
	cat index.html | grep "href" | cut -d "=" -f2 | grep "\.com" | cut -d ">" -f1 | tr -d '"' | cut -d ":" -f2 | tr -d "//" > parsing_list.txt
	cat parsing_list.txt
	
	echo ""
	echo " ========================================================== "
	echo " =========== Listando IPs dos subdomínios ... ============= "
	echo " ========================================================== "
	echo ""
	for line in $(cat parsing_list.txt)
	do
	host $line
	done

fi
