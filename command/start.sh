## Step 2: faucet
cd /root/tracks
go run cmd/main.go create-station --accountName $MONIKER --accountPath $HOME/.tracks/junction-accounts/keys --jsonRPC $RPC_AIR --info "EVM Track" --tracks $ADDRESS --bootstrapNode "/ip4/$USERIP/tcp/2300/p2p/$NODEID"
tmux new-session -d -s 1
tmux send-keys -t 1 'go run cmd/main.go start' C-m
git clone https://github.com/pnam1609/airchain-rollup
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh
source ~/.bashrc
nvm install v16.13.1
nvm use v16.13.1
cd /root/airchain-rollup
npm i
npm run start