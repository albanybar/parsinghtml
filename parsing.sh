#!/bin/bash

#Script for parsing - MAP3300

if [ "$1" == "" ]
then
	echo -e "\033[01;36m[+] $0 - SCRIPT PARSING - MAP3300 [+]\033[01;37m"
	echo "EXAMPLE:"
	echo "$0 url"
	echo "$0 example.com.uk"
else
	#get the url to teste
	url=$1;
	
	#start looping until close action
	exit=y;
	while [ $exit != 'n' ]
	do
		#show the domain for parsing
		echo ""
		echo -e "\033[01;35m==========================================================================================="
		echo ""
		echo -e "\033[01;32m                             [+] Solving URLs in: \033[01;34m$url"
		echo ""
        	echo -e "\033[01;35m==========================================================================================="
		echo -e "\033[01;37m"

		#capture the html code to parsing and save in temporary file
		wget -q $url -O temp;

		#filter the output for just address to solve ip and save to list
		cat temp | grep "href" |cut -d "/" -f 3 | grep "\." | cut -d '"' -f 1 | grep -v '<li' | grep -v '(' | grep -v 'javascript' | grep -v '<a'> list;

		#Removing duplicates address
		cat list | sort | uniq -u > list2


		echo -e "\033[01;35m==========================================================================================="
        	echo -e "\033[01;37m               LINE                   IP                    ADDRESS"
        	echo -e "\033[01;35m===========================================================================================\033[01;37m"

		#Solving host in list and save in ips.txt
		#Counting lines
		lines=1;
		for urlline in $(cat list2)
		do
			ip=$(host $urlline | grep -v "NXDOMAIN" | cut -d " " -f 4 | grep -v 'address' | grep -v 'alias' );
			#In case url it is already a IP.
			if [ "$ip" == "" ]
			then
			ip=$(echo "$urlline" | cut -d ':' -f 1 );
			fi
			echo -n "$lines:$ip:$urlline" >> $url.txt;
			echo "                 $lines              $ip               $urlline";
			echo "" >> $url.txt;
			lines=$((lines+1));
		done

		#Removing temporary files habilitar somente depois do script completo e colocar nome randomico para evitar conflitos
		rm -rf list;
		rm -rf list2;
		rm -rf temp;

		echo -e "\033[01;31m[+]  Finished: Saving results in $1.txt\033[01;37m"

		#Asking to repeat parsing
		echo -e "\033[01;33mParsing another url?(y/n)";
		read exit;

		if [ $exit != "n" ]
		then
			#read the url again
			echo -e "\033[01;33mURL:"
			read url
			echo "$url"
		fi # end of  non-exit case
	done  #end while

fi
