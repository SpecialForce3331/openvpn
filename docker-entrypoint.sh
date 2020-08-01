#!/bin/bash
EASYRSA="EasyRSA-3.0.7"

if [ ! -f "/keys/easyrsa" ]; then
echo "Downloading easy-rsa..."
cd /keys 
wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.7/${EASYRSA}.tgz
tar -zxf ${EASYRSA}.tgz --strip 1
cp /vars .

echo "Initializing pki...";
./easyrsa init-pki;
echo "Building CA...";
./easyrsa build-ca nopass;
echo "Building DH file...";
./easyrsa gen-dh;
echo "Generating server key...";
./easyrsa gen-req srv-openvpn nopass;
./easyrsa sign-req server srv-openvpn;

openvpn --genkey --secret /etc/openvpn/ta.key
cp /etc/openvpn/ta.key /keys/pki/
else
cp /keys/pki/ta.key /etc/openvpn/
fi

cp /keys/pki/ca.crt /etc/openvpn/
cp /keys/pki/dh.pem /etc/openvpn/
cp /keys/pki/private/srv-openvpn.key /etc/openvpn/
cp /keys/pki/issued/srv-openvpn.crt /etc/openvpn/

mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
  mknod /dev/net/tun c 10 200
fi

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

chmod -R 777 /keys

openvpn --config /etc/openvpn/openvpn.conf
