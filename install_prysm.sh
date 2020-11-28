#!/bin/bash

# Download beacon and validator binaries using prysm script
curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output ./prysm.sh && chmod +x ./prysm.sh
./prysm.sh beacon-chain --download-only
./prysm.sh validator --download-only

# Create beacon user and directory
sudo useradd --no-create-home --shell /bin/false prysmbeacon
sudo mkdir -p /var/lib/prysm/beacon
sudo chown -R prysmbeacon:prysmbeacon /var/lib/prysm/beacon

# Create validator user and directory
sudo useradd --no-create-home --shell /bin/false prysmvalidator
sudo mkdir -p /var/lib/prysm/validator
sudo chown -R prysmvalidator:prysmvalidator /var/lib/prysm/validator

# Import account
sudo ./prysm.sh validator accounts import --keys-dir=./validator_keys --accept-terms-of-use --pyrmont --wallet-password-file ./validator_keys/wallet_password.txt --wallet-dir /var/lib/prysm/validator --account-password-file ./validator_keys/account_password.txt

# Copy wallet password file for validator to read
sudo cp ./validator_keys/wallet_password.txt /var/lib/prysm/validator/wallet_password.txt
sudo chown prysmvalidator:prysmvalidator /var/lib/prysm/validator/wallet_password.txt
sudo chmod go-rw /var/lib/prysm/validator/wallet_password.txt

# Copy binaries to bin
sudo cp dist/beacon*amd64 /usr/local/bin/beacon-chain
sudo cp dist/validator*amd64 /usr/local/bin/validator

# Create(copy) and start services
sudo cp *.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start prysmbeacon
sudo systemctl start prysmvalidator
sudo systemctl enable prysmbeacon
sudo systemctl enable prysmvalidator
