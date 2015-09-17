#!/bin/bash

echo '   ___                   ____ ____  _     ____                  '
echo '  / _ \ _ __   ___ _ __ / ___/ ___|| |   / ___|  ___ __ _ _ __  '
echo ' | | | | '"'"'_ \ / _ \ '"'"'_ \\___ \___ \| |   \___ \ / __/ _` | '"'"'_ \ '
echo ' | |_| | |_) |  __/ | | |___) |__) | |___ ___) | (_| (_| | | | |'
echo '  \___/| .__/ \___|_| |_|____/____/|_____|____/ \___\__,_|_| |_|'
echo '       |_|                                                      '
echo

. ./check_openssl.sh

if [[ ! -e "ciphers.conf" ]]; then
	echo "[X] Please run ./build_ciphers.sh first"
	exit 1
fi

if [[ "$1" == "" ]]; then
	echo "Usage: ./sslscan.sh <host:port> [-a]"
	echo -e " -a\t- Display unsupported ciphers"
	exit 1
fi

TARGET="$1"
HOST=$(echo $TARGET | cut -d':' -f1)
PORT=$(echo $TARGET | cut -d':' -f2)

echo 1 | nc -w 3 $HOST $PORT > /dev/null
if [[ $? -ne 0 ]]; then
	echo "[X] $TARGET could not be reached on port $PORT, abort !"
	exit 2
fi

for protocol in ssl3 tls1 tls1_1 tls1_2; do

	SMALLPROTO=$(echo $protocol | sed -r 's/^(....).+$/\1/g')

	openssl ciphers ALL:COMPLEMENTOFALL -$SMALLPROTO | tr ':' '\n' | while read cipher; do

		echo | openssl s_client -connect "$TARGET" -cipher $cipher -$protocol 2>&1 | fgrep 'Cipher is (NONE)' >/dev/null
		EXITCODE=$?
		CAT=$(cat ciphers.conf | egrep '^'$cipher':' | grep $SMALLPROTO | cut -d':' -f3)
		
		if [[ "$CAT" == "" ]]; then
			CAT='**UNKNOWN**'
		fi

		if [[ $EXITCODE -eq 1 ]]; then
			echo -e "[+] Supports\tPROTO=$protocol\tCIPHER=$cipher\t\t[$CAT]"
		else
			if [[ "$2" == "-a" ]]; then
				echo -e "[!] No support for \tPROTO=$protocol\tCIPHER=$cipher\t\t[$CAT]"
			fi
		fi	
		
	done

done
