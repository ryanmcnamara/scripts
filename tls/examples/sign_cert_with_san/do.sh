## generate server private key
openssl genrsa -out out/key.pem 2048

openssl req -new -sha256 \
    -key out/key.pem \
    -reqexts v3_req \
    -config in/req.conf \
    -out out/csr.pem

# openssl x509 -req -in out/csr.pem -CA in/cert.pem -CAkey in/key.pem -CAcreateserial -out out/cert.pem -days 500 -sha256 -extfile in/req.conf -extensions v3_req
openssl x509 -req -in out/csr.pem -CA in/cert.pem -CAkey in/key.pem -set_serial 1 -out out/cert.pem -days 500 -sha256 -extfile in/req.conf -extensions v3_req
