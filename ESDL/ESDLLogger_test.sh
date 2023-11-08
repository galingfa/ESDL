#!/bin/bash
echo "##################################################"
echo "################# EVENTUS LOGGER #################"
echo "##################################################"
echo " "
echo " "
echo "This is the installation of EVENTUS LOGGER which would collect and forward logs from your on-premise devices to ESDL SaaS."
echo "Please press Yes to confirm or No to abort."
read -p "Press Yes to confirm or No to abort: " confirmation
if [[ "$confirmation" != "Yes" ]] && [[ "$confirmation" != "Y" ]] && [[ "$confirmation" != "YES" ]] && [[ "$confirmation" != "yes" ]] && [[ "$confirmation" != "y" ]]; then
    echo "Installation aborted."
    exit 1
fi

echo " "
echo "Downloading and installing ESDL Logger component..."
echo " "

sudo apt update
sudo apt install rsyslog -y

echo " "
echo "ESDL Logger component successfully installed."
echo " "

sudo apt update
sudo apt install rsyslog -y

echo " "
echo "Enabling logger service to start at boot..."
echo " "

sudo systemctl enable rsyslog

echo " "
echo "TLS Certificates..."
echo " "

echo " "
echo "Installing GTLS for Encryption..."
echo " "

sudo apt-get install rsyslog-gnutls

echo " "
echo "Generating the Certificate Authority (CA) certificate and key for client..."
echo " "

# For CA Certificate (ca.crt) and CA Key (ca.key)
sudo openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes -out /etc/rsyslog.d/ca.crt -keyout /etc/rsyslog.d/ca.key

echo " "
echo "Generating the client certificate signing request (CSR) and key..."
echo " "

# For Client Certificate Signing Request (client.csr) and Client Key (client.key):
sudo openssl req -newkey rsa:4096 -sha256 -nodes -out /etc/rsyslog.d/client.csr -keyout /etc/rsyslog.d/client.key

echo " "
echo "Signing the client certificate using the CA certificate and key..."
echo " "

# For Client Certificate (client.crt):
sudo openssl x509 -req -in /etc/rsyslog.d/client.csr -CA /etc/rsyslog.d/ca.crt -CAkey /etc/rsyslog.d/ca.key -CAcreateserial -out /etc/rsyslog.d/client.crt -days 365 -sha256

echo " "
echo "Restarting ESDL Logger service to apply the changes..."
echo " "

sudo systemctl restart rsyslog

# Check the status of the rsyslog service and display a message
if sudo systemctl is-active --quiet rsyslog; then
    echo "ESDL Logger has been successfully configured with TLS and certificates."
else
    echo "There was an issue configuring rsyslog with TLS and certificates."
fi


python3 insert_config.py

echo " "
echo "Successfully connected to ESDL SaaS"
echo " "