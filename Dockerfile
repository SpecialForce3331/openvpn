from ubuntu:18.04

WORKDIR /root
RUN apt update && apt install openvpn wget iptables -y && mkdir /keys
COPY vars /vars
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh 
COPY openvpn.conf /etc/openvpn/

ENTRYPOINT /docker-entrypoint.sh
