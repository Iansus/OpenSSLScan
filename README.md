OpenSSLScan
===========

SSL Cipher enumeration using OpenSSL.

## Install

- Untar your favorite OpenSSL version in `openssl` OR see the Tweaking section to link it to your openssl installation
- `./build_ciphers.sh`


## Run

```
Usage: ./opensslscan.sh <host:port> [-a]
-a  - Display unsupported ciphers
```


## Tweaking

- OpenSSL location can be modified in `check_openssl.sh`
- `rfc/classes.txt` is built from the official OpenSSL man page and lists all the existant cipher suite classes