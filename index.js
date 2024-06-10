const { Web3 } = require("web3");
// require("dotenv").config();

const rpcUrl = process.env.RPC_EVM;
const receiverAddress = process.env.RECEIVER_ADDRESS;
const rawPrivateKey = process.env.PRIVATE_KEY;

const privateKey = "0x" + rawPrivateKey;

console.log("rpcUrl", rpcUrl);
console.log("receiverAddress", receiverAddress);
console.log("privateKey", privateKey);

if (!rpcUrl || !receiverAddress || !privateKey) {
  console.error("One or more environment variables are missing");
  process.exit(1);
}

// Connect to your Ethereum node
const web3 = new Web3(new Web3.providers.HttpProvider(rpcUrl));

// Check connection
web3.eth.net
  .isListening()
  .then(() => {
    console.log("Connection successful");
  })
  .catch((e) => {
    console.log("Connection failed");
    process.exit(1);
  });

const account = web3.eth.accounts.privateKeyToAccount(privateKey);
const senderAddress = account.address;

console.log("senderAddress", senderAddress);

async function sendTransaction() {
  try {
    // const nonce = await web3.eth.getTransactionCount(senderAddress, "pending");
    // console.log(`Fetched nonce: ${nonce}`);

    const createTransaction = await web3.eth.accounts.signTransaction(
      {
        gas: 21000,
        to: receiverAddress,
        value: web3.utils.toWei("1", "ether"),
        gasPrice: await web3.eth.getGasPrice(),
        nonce: await web3.eth.getTransactionCount(senderAddress),
      },
      privateKey
    );

    // 5. Send transaction and wait for receipt
    const createReceipt = await web3.eth.sendSignedTransaction(
      createTransaction.rawTransaction
    );
    console.log(`Transaction sent with hash: ${JSON.stringify(createReceipt)}`);
    return createReceipt;
  } catch (e) {
    console.log(`An error occurred: ${e}`);
    return null;
  }
}

async function main() {
  while (true) {
    for (let i = 0; i < 25; i++) {
      console.log("index", i);
      await sendTransaction();
    }
    console.log("Waiting 3 seconds before restarting the loop...");
    await new Promise((resolve) => setTimeout(resolve, 3000)); // Sleep for 3 seconds
  }
}

main();
