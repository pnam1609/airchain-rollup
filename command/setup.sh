#!/bin/bash
chmod +x /root/airchain-rollup/command/config/config.sh
chmod +x /root/airchain-rollup/command/config/station.sh

# Run the first script
./config/config.sh

# Check if the first script executed successfully
if [ $? -ne 0 ];    then
  echo "config.sh failed"
  exit 1
fi

# Run the second script
./config/station.sh

# Check if the second script executed successfully
if [ $? -ne 0 ]; then
  echo "station.sh failed"
  exit 1
fi

echo "Get the Address to faucet"
echo $ADDRESS