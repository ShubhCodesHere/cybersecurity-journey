#!/bin/bash
#A bash script to create a directory structure for a cybersec engagement.
DOMAIN=$1

if [ -z "$DOMAIN" ]; then 
	echo -e "\e[31m[-]Usage: script.sh target.com \e[0m"
	exit 1
	
else
	mkdir -p "$DOMAIN"
	mkdir -p "$DOMAIN/recon"
	mkdir -p "$DOMAIN/exploits"
	mkdir -p "$DOMAIN/evidence"
	echo -e "\e[32m[+] Files created succesfully and the current working directory is " 
	cd "$DOMAIN" 
	pwd
fi
exit 0
