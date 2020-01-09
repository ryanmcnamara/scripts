openssl req -newkey rsa:2048 -nodes -keyout out/key.pem -x509 -days 365 -out out/cert.pem -subj '/CN=localhost'
