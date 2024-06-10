#!/bin/bash
chmod +x start/create-station.sh
chmod +x start/script-transfer.sh

# Run the first script
./start/create-station.sh

# Check if the first script executed successfully
if [ $? -ne 0 ];    then
  echo "create-station.sh failed"
  exit 1
fi

# Run the second script
./start/script-transfer.sh

# Check if the second script executed successfully
if [ $? -ne 0 ]; then
  echo "script-transfer.sh failed"
  exit 1
fi
