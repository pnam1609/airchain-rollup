## create station and start: Need facuet first
cd /root/tracks
go run cmd/main.go create-station --accountName $MONIKER --accountPath $HOME/.tracks/junction-accounts/keys --jsonRPC $RPC_AIR --info "EVM Track" --tracks $ADDRESS --bootstrapNode "/ip4/$USERIP/tcp/2300/p2p/$NODEID"
cd /root/tracks
tmux new-session -d -s 1
tmux send-keys -t 1 'go run cmd/main.go start' C-m