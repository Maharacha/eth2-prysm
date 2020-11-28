# eth2-prysm
Scripts for setting up beacon and validator with prysm.

## Install
1. Clone this repo.
2. Set eth1 node address in `prysmbeacon.service` (`--http-web3provider=`)
2. Inside repo directory, put your `validator_keys` directory
3. Inside `validator_keys` directory, put your desired wallet password in `wallet_password.txt`.
4. Inside `validator_keys` directory, put your account password in `account_password.txt`. This was chosen when creating the keys using `deposit`.
5. From inside repo directory, run `sudo ./install_prysm.sh`.
6. When everything is up and running, the `validator_keys` directory can be removed.

## Useful commands
`sudo service prysmbeacon status/stop/start/restart`  
`sudo journalctl -fu prysmbeacon.service`

`beaconchain` can be replaced with `validator` for the validator service.  
