# validate that a cert and private key match

openssl x509 -noout -modulus -in in/cert.pem | openssl md5
openssl rsa -noout -modulus -in in/key.pem | openssl md5

echo previous lines should be the same

