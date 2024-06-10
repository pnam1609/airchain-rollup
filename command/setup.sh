#!/bin/bash
## Step 0 Change config variable in Step 1: MONIKER, RECEIVER_ADDRESS, USERIP, RPC_AIR ( Optional )
## Step 1 Copy cmd to run until faucet step
#!/bin/bash

# Update package list
cd
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install golang-go jq

git clone https://github.com/airchains-network/evm-station.git
git clone https://github.com/airchains-network/tracks.git
echo 'export RPC_EVM=http://$USERIP:8545' >> /root/.bashrc
echo "export DA_TYPE=celestia" >> /root/.bashrc
echo "export RPC_DA=https://celestia-testnet-rpc.itrocket.net" >> /root/.bashrc
source /root/.bashrc

cd /root/evm-station
go mod tidy
cd /root/evm-station
/bin/bash ./scripts/local-setup.sh
sed -i 's/address = "127.0.0.1:8545"/address = "0.0.0.0:8545"/g' /root/.evmosd/config/app.toml
tmux new-session -d -s 0
tmux send-keys -t 0 'cd /root/evm-station' C-m
tmux send-keys -t 0 '/bin/bash ./scripts/local-start.sh' C-m

sleep 5
echo "export PRIVATE_KEY=$(/bin/bash ./scripts/local-keys.sh )" >> /root/.bashrc
source /root/.bashrc
cd
sudo rm -rf ~/.tracks
cd /root/tracks
go mod tidy
go run cmd/main.go init --daRpc $RPC_DA --daKey "daKey" --daType $DA_TYPE --moniker $MONIKER --stationRpc "http://127.0.0.1:8545" --stationAPI "http://127.0.0.1:8545" --stationType "evm"
go run cmd/main.go keys junction --accountName $MONIKER --accountPath $HOME/.tracks/junction-accounts/keys
cp /root/.tracks/junction-accounts/keys/${MONIKER}.wallet.json /root
go run cmd/main.go prover v1EVM
export NODEID=$(sudo grep 'node_id' /root/.tracks/config/sequencer.toml | awk -F'=' '{print $2}' | tr -d ' "')
echo "export NODEID=$NODEID" >> /root/.bashrc
echo "export ADDRESS=$(jq -r '.address' /root/.tracks/junction-accounts/keys/${MONIKER}.wallet.json)" >> ~/.bashrc
source /root/.bashrc

echo "Get the Address to faucet"
echo $ADDRESS