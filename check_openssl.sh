#!/bin/bash

OPENSSL_DIR='openssl'
OPENSSL=$OPENSSL_DIR'/apps/openssl'

if [[ ! -e "$OPENSSL" ]]; then
	echo "[X] Please install openssl in openssl/ directory --> cannot find $OPENSSL"
	echo "[X] Please run $OPENSSL_DIR/build_all.sh"
	exit 3
fi

echo -n "[+] Using "
$OPENSSL version
