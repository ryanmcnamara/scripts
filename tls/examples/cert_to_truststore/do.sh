# convert cert to truststore.jks

keytool -import -alias 1 -file in/cert.pem -storetype JKS -keystore out/truststore.jks

