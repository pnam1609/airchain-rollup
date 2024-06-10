## Step 0 Change config variable in Step 1: MONIKER, RECEIVER_ADDRESS, USERIP, RPC_AIR ( Optional )
## Step 1 Copy cmd to run until faucet step
#!/bin/bash

# Update package list
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install golang-go jq

git clone https://github.com/airchains-network/evm-station.git
git clone https://github.com/airchains-network/tracks.git
echo 'export RPC_EVM=http://$USERIP:8545' >> /root/.bashrc
echo "export DA_TYPE=celestia" >> /root/.bashrc
echo "export RPC_DA=https://celestia-testnet-rpc.itrocket.net" >> /root/.bashrc
source /root/.bashrc