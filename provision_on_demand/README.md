
# Setup CA:
Generate new private key cert for CA:
```bash
export OPENSSL_CONF=CA.conf
mkdir ca_data && touch ca_data/index.txt && echo '01' > ca_data/serial
openssl genrsa                                      \
    -out ca_data/rootCA.private.key    # NB: add `-des3` to genrsa command to have privatekey with password

openssl req -new -sha256 -nodes                     \
    -key ca_data/rootCA.private.key                     \
    -out ca_data/rootCA.public.key                             \
    -subj "/C=UK/ST=London/L=London/O=barnes-webb.com/CN=Richard Barnes-Webb IoT CA"    

openssl x509 -req -days 3650 -extensions v3_ca      \
    -in      ca_data/rootCA.csr                         \
    -signkey ca_data/rootCA.private.key                 \
    -out     ca_data/rootCA.public.cer


```

openssl req  -new -x509 -days 3650                                                          \
        -subj "/C=UK/ST=London/L=London/O=barnes-webb.com/CN=Richard Barnes-Webb IoT CA"    \
        -key ca_data/rootCA.private.key                                                         \
        -out ca_data/rootCA.public.cer                                                           
