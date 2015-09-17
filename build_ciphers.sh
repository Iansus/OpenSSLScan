#!/bin/bash

. ./check_openssl.sh

rm -rf categories 2> /dev/null
mkdir categories 2> /dev/null

if [[ ! -e "rfc/classes.txt" ]]; then
	echo "[X] rfc/classes.txt is missing, abort !"
	exit 1
fi

for protocol in ssl2 ssl3 tls1; do

	mkdir categories/$protocol/ 2>/dev/null

	cat rfc/classes.txt | while read category; do
		echo -n "[+] Building '$category' ($protocol) ciphers"
		$OPENSSL ciphers $category -$protocol 2>/dev/null > tmp.txt

		if [[ $? -eq 0 ]]; then
			echo "  done !"
			cat tmp.txt |tr ':' '\n' > categories/$protocol/$category.txt
		else
			echo "  does not exist on this system"
		fi
		rm tmp.txt
	done
done

./arrange_ciphers.py > ciphers.conf
