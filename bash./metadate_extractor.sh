#!/bin/bash

if [[ $# == 0 || $# -ge 3 || $# == 1 ]]; then

	echo "  ██████╗ ██╗   ██╗██╗ ██████╗██╗  ██╗███╗   ███╗███████╗████████╗ █████╗ "
	echo " ██╔═══██╗██║   ██║██║██╔════╝██║  ██║████╗ ████║██╔════╝╚══██╔══╝██╔══██╗"
	echo " ██║   ██║██║   ██║██║██║     ██████║ ██╔████╔██║█████╗     ██║   ███████║"
	echo " ██║▄▄ ██║██║   ██║██║██║     ██╔══██║██║╚██╔╝██║██╔══╝     ██║   ██╔══██║"
	echo " ╚██████╔╝╚██████╔╝██║╚██████╗██║  ██║██║ ╚═╝ ██║███████╗   ██║   ██║  ██║"
	echo "  ╚══▀▀═╝  ╚═════╝ ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝"
	echo ""
	echo "Objetivo: Avaliar a exposição de metadados de um determinado domínio."
	echo "Funcionamento: Realiza uma dork por extensões em um motor de busca pré-definido,"
	echo "               utiliza lynx como browser cli e exiftool para extração de metadados."
	echo ""
	echo "O script necessita de dois argumentos para ser executado."
	echo "Ex.: ./$0 <domínio> <extensão do arquivo>"
	echo "Extensões válidas: pdf, txt, pptx, doc, docx"

else

	echo " ██████╗ ██╗   ██╗██╗ ██████╗██╗  ██╗███╗   ███╗███████╗████████╗ █████╗ "
	echo "██╔═══██╗██║   ██║██║██╔════╝██║  ██║████╗ ████║██╔════╝╚══██╔══╝██╔══██╗"
	echo "██║   ██║██║   ██║██║██║     ██████║ ██╔████╔██║█████╗     ██║   ███████║"
	echo "██║▄▄ ██║██║   ██║██║██║     ██╔══██║██║╚██╔╝██║██╔══╝     ██║   ██╔══██║"
	echo "╚██████╔╝╚██████╔╝██║╚██████╗██║  ██║██║ ╚═╝ ██║███████╗   ██║   ██║  ██║"
	echo " ╚══▀▀═╝  ╚═════╝ ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝"
	echo ""
	echo "Criando diretório para armazenamento de arquivos no diretório atual ..."
	mkdir -p "$1" && cd "$1"
        echo "Iniciando coleta via google.com ..."
	if [ "$2" == "pdf" ]; then
		lynx --dump "https://google.com/search?&q=site:$1+ext:pdf" | grep "https://www.google" | cut -d "=" -f2 | grep "://" | cut -d "&" -f1 | grep ".$2" > files_urls.txt
	elif [ "$2" == "txt" ]; then
		lynx --dump "https://google.com/search?&q=site:$1+ext:txt" | grep "https://www.google" | cut -d "=" -f2 | grep "://" | cut -d "&" -f1 | grep ".$2" > files_urls.txt
	elif [ "$2" == "pptx" ]; then
		lynx --dump "https://www.google.com/search?&q=site:$1+ext:pptx" | grep "https://www.google" | cut -d "=" -f2 | grep "://" | cut -d "&" -f1 | grep ".$2" > files_urls.txt
	elif [ "$2" == "doc" ]; then
                lynx --dump "https://www.google.com/search?&q=site:$1+ext:doc" | grep "https://www.google" | cut -d "=" -f2 | grep "://" | cut -d "&" -f1 | grep ".$2" > files_urls.txt
	elif [ "$2" == "docx" ]; then
		lynx --dump "https://www.google.com/search?&q=site:$1+ext:docx" | grep "https://www.google" | cut -d "=" -f2 | grep "://" | cut -d "&" -f1 | grep ".$2" > files_urls.txt
	fi
	echo ""
	echo ":::::::::::::::::::: URLS DOS ARQUIVOS ::::::::::::::::::::"
	cat "files_urls.txt" 2> /dev/null
	echo ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
	echo ""

	for line in $(cat files_urls.txt); do
		echo "Baixando $line..."
		wget $line 2
	done

	echo "Iniciando extração de metadados ..."
	for line in $(cat files_urls.txt); do
		IFS="/" read -ra array <<< $line
		l=${#array[@]}
		file_index=l-1
		name_file="${array[$file_index]}"
		echo "::::::::::::::::::::::::: METADADOS - $name_file :::::::::::::::::::::::::"
		exiftool "$name_file" >> extractor_log.txt
		exiftool "$name_file" 2> /dev/null
		echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
		echo ""
	done
fi
