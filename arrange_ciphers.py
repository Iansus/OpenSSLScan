#!/bin/env python

import os, sys

CATEGORIES='categories'
PROTOCOLS=['ssl2', 'ssl3', 'tls1']
CIPHERS = {p:{} for p in PROTOCOLS}

for protocol in PROTOCOLS:
	protoDir = os.path.join(CATEGORIES, protocol)

	if os.path.isdir(protoDir):
		for fname in [e for e in os.listdir(protoDir) if '.txt' in e]:
			category = fname.replace('.txt', '')
			f = open(os.path.join(protoDir, fname), 'r')
			for cipher in f:
				cipher = cipher.replace('\n','')
				if not cipher in CIPHERS[protocol].keys():
					CIPHERS[protocol][cipher] = []

				if category not in CIPHERS[protocol][cipher]:
					CIPHERS[protocol][cipher].append(category)

			f.close()

	print '\n'.join(['%s:%s:%s' % (c, protocol, ','.join(cats)) for c, cats in CIPHERS[protocol].items()])

