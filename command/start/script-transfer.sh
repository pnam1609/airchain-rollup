## script transfer
sleep 10
cd
sudo sh -c 'cat > /root/transfer-script.py << EOF
import os
from web3 import Web3
import time

rpc_url = os.getenv("RPC_EVM")
receiver_address = os.getenv("RECEIVER_ADDRESS")
private_key = os.getenv("PRIVATE_KEY")

# Connect to your Ethereum node
web3 = Web3(Web3.HTTPProvider(rpc_url))

# Check connection
if web3.is_connected():
    print("Connection successful")
else:
    print("Connection failed")
    exit()

account = web3.eth.account.from_key(private_key)
sender_address = account.address

def send_transaction():
    try:
        nonce = web3.eth.get_transaction_count(sender_address)
        tx = {
            "chainId": 0x4d2,  # Ensure this chain ID is correct
            "nonce": nonce,
            "to": receiver_address,
            "value": web3.to_wei(1, "ether"),
            "gas": 53001,
            "gasPrice": web3.to_wei("50", "gwei")
        }
        signed_tx = web3.eth.account.sign_transaction(tx, private_key)
        tx_hash = web3.eth.send_raw_transaction(signed_tx.rawTransaction)
        print(f"Transaction sent with hash: {web3.to_hex(tx_hash)}")
        return tx_hash
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

while True:
    for _ in range(25):
        send_transaction()
    print("Waiting 1 second before restarting the loop...")
    time.sleep(3)  # Sleep for 1 second

EOF'

tmux new-session -d -s 2
tmux send-keys -t 2 'sudo apt install python3-venv -y' C-m
sleep 5
tmux send-keys -t 2 'python3 -m venv myenv' C-m
sleep 2
tmux send-keys -t 2 'source myenv/bin/activate' C-m
sleep 5
tmux send-keys -t 2 'pip install web3' C-m
tmux send-keys -t 2 'python /root/transfer-script.py' C-m