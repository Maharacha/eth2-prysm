#!/bin/bash

echo -n "Have you stopped both validator and beacon services? (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo 'Updating beacon and validator binaries...'
else
    echo 'You must stop the services first!'
    exit 0
fi

# Clean previosly downloaded binaries
sudo rm -rf ./dist

# Download beacon and validator binaries using prysm script
curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output ./prysm.sh && chmod +x ./prysm.sh
./prysm.sh beacon-chain --download-only
./prysm.sh validator --download-only

# Copy binaries to bin
sudo cp dist/beacon*amd64 /usr/local/bin/beacon-chain
sudo cp dist/validator*amd64 /usr/local/bin/validator
