# convert key and cert to keystore.jks

## convert cert and key pem encoded files to combined pem encoded cert
cat in/cert.pem in/key.pem > out/combined.pem

## convert combined pem encoded cert to pkcs12 format (requires password)
openssl pkcs12 -export -in out/combined.pem -out out/cert.pkcs12

## convert pkcs12 format to keystore
keytool -importkeystore -srckeystore out/cert.pkcs12 -srcstoretype pkcs12 -destkeystore out/keystore.jks 
