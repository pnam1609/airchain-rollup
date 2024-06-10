cd /root/evm-station
go mod tidy
/bin/bash ./scripts/local-setup.sh
sed -i 's/address = "127.0.0.1:8545"/address = "0.0.0.0:8545"/g' /root/.evmosd/config/app.toml
tmux new-session -d -s 0
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
echo "export    =$(jq -r '.address' /root/.tracks/junction-accounts/keys/${MONIKER}.wallet.json)" >> ~/.bashrc
source /root/.bashrc