## generate server private key
openssl genrsa -out out/key.pem 2048

## generate server csr
openssl req -new -sha256 -key out/key.pem -subj "/CN=localhost2" -out out/csr.pem

## sign the csr and produce the cert
openssl x509 -req -in out/csr.pem -CA in/cert.pem -CAkey in/key.pem -set_serial 1 -out out/cert.pem -days 500 -sha256


