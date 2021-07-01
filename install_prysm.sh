#!/bin/bash

# Download beacon and validator binaries using prysm script
curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output ./prysm.sh && chmod +x ./prysm.sh
./prysm.sh beacon-chain --download-only
./prysm.sh validator --download-only

# Create beacon user and directory
sudo groupadd -g 1001 prysmbeacon
sudo useradd -u 1001 -g 1001 --no-create-home --shell /bin/false prysmbeacon
sudo mkdir -p /var/lib/prysm/beacon
sudo chown -R prysmbeacon:prysmbeacon /var/lib/prysm/beacon

# Create validator user and directory
sudo groupadd -g 1002 prysmvalidator
sudo useradd -u 1002 -g 1002 --no-create-home --shell /bin/false prysmvalidator
sudo mkdir -p /var/lib/prysm/validator
sudo chown -R prysmvalidator:prysmvalidator /var/lib/prysm/validator

# Import account
sudo ./prysm.sh validator accounts import --keys-dir=./validator_keys --accept-terms-of-use --wallet-password-file ./validator_keys/wallet_password.txt --wallet-dir /var/lib/prysm/validator --account-password-file ./validator_keys/account_password.txt

# Copy wallet password file for validator to read
sudo cp ./validator_keys/wallet_password.txt /var/lib/prysm/validator/wallet_password.txt
sudo chown prysmvalidator:prysmvalidator /var/lib/prysm/validator/wallet_password.txt
sudo chown -R prysmvalidator:prysmvalidator /var/lib/prysm/validator
sudo chmod -R 0700 /var/lib/prysm/validator

# Copy binaries to bin
sudo cp dist/beacon*amd64 /usr/local/bin/beacon-chain
sudo cp dist/validator*amd64 /usr/local/bin/validator

# Create(copy) and start services
sudo cp *.service /etc/systemd/system/
sudo systemctl daemon-reload

# Don't automatically start the service, since one might want to copy a backup validator directory containing slashing protection history (.db).
#sudo systemctl start prysmbeacon
#sudo systemctl start prysmvalidator

# Don't want service to start on boot in case another instance starts while validator is already running on one. Slashing!!
# sudo systemctl enable prysmbeacon
# sudo systemctl enable prysmvalidator
