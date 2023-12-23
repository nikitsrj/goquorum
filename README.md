<img src="https://raw.githubusercontent.com/ConsenSys/quorum-hashicorp-vault-plugin/main/img/QuorumLogo_Blue.png" height="120" width="350"/>

# Goquorum
This repository includes goquorum quicksetup on a single Node VM as well as on K8S. It also includes the interaction with the network using GETH. Post that it includes how to create a dAPP and deploy it in local network and how we can leverage on some devsecops toolchain for automated and secure deployment of dApp. At the end we will cover the production grade consideration for GoQuorum Network.

> Please Note that this repository code and script will include some manual inputs, so its not a fully automated system for the deployment. Please do look out for comment in the scripts.

## Quorum Blockchain Network

### Quorum
A soft fork of the public Ethereum Blockchain

Primary Features
- Privacy. Transactions and smart contracts on the blockchain can be private.
- Voting-based consensus mechanisms. Raft-based and Istanbul Byzantine Fault Tolerance (BFT) consensus mechanisms.
- Peer/node permissioning using smart contracts, which ensures that only known parties can join the network
- Increased scalability and network performance.

**Basic Architecture**

<img src="https://docs.goquorum.consensys.io/assets/images/Quorum%20Design-0b8564f1a845d87d0679b057df55561b.png" height="300" width="600"/>

- Quorum Node: Allows voting based consensus mechanism instead of proof of work and allowing transaction and smart contract to be privately executed
- Constellation: Implements the privacy feature of Quorum
    1. A transaction manager stores and allows access to encrypted transaction data, exchanges encrypted payloads with other participants' transaction manager, but don't have access to any sensitive private key. 
    2. Enclave works with the transaction manager to strengthen the privacy by managing encryption and decryption in an isolated way. The enclave stores private keys and is essentially a virtual HSM or hardware security module which is an encryption method 

Private Transaction workflow between where A and B are party of the transaction and C is not.

<img src="https://docs.goquorum.consensys.io/assets/images/PrivateTxnFlow-4be49699f8855987f6e8dfd56a950b1a.png" height="600" width="600"/>


**Quick Setup in an AWS EC2 instance** 

Quorum dev quickstart provides the steps to simply setup a 7 node blockchain network. This 7 node will be running as container in a single VM.<br>
Spin up an EC2 instance of 8 core and 32 GB RAM(t2.2xlarge), ubuntu with 80GB storage. For testing purpose pls open all the ports to your home IP.<br>

Take a look at the `quorum-dev-quickstart-steps.sh` file


This setup will create following components:
- Four GoQuorum IBFT validator nodes and a RPC non-validator node are created to simulate a base network.<br>
- In addition, there are three member pairs (GoQuorum and Tessera sets) to simulate private nodes on the network.<br>
- Apart from these, there are some management and monitoring components like chainlens, Web Explorer, blockscout, Loki, Prometheus and Grafana.<br>

We will install cakeshop to interact with the network via UI.<br>
The installation step is mentioned in `quorum-dev-quickstart-steps.sh` file.<br>

So the list of endpoint for this quickstart setup will be like following.

JSON-RPC HTTP service endpoint                 : http://localhost:8545<br>
JSON-RPC WebSocket service endpoint            : ws://localhost:8546<br>
Web block explorer address                     : http://localhost:25000/explorer/nodes<br>
Chainlens address                              : http://localhost:8081/<br>
Blockscout address                             : http://localhost:26000/<br>
Prometheus address                             : http://localhost:9090/graph<br>
Grafana address                                : http://localhost:3000/d/a1lVy7ycin9Yv/goquorum-overview?orgId=1&refresh=10s&from=now-30m&to=now&var-system=All<br>
Collated logs using Grafana and Loki           : http://localhost:3000/d/Ak6eXLsPxFemKYKEXfcH/quorum-logs-loki?orgId=1&var-app=quorum&var-search=<br>
Cakeshop                                       : http://localhost:8999<br>

> Note: I will touch the Production Grade Qourum Network later.

## GETH API and Blockchain Transaction Demonstration

There are steps at the end in `quorum-dev-quickstart-steps.sh` file, which will install `geth` cli in the same VM<br>

There are multiple ways to interact with BlockChain Network API, one is via `curl` and another is via `geth` js interactive.

**Inspecting nodes/peers information**

```
geth attach http://localhost:8545
eth.accounts
admin.nodeInfo
admin.peers
admin.peers.length
```

```
curl -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' -H 'Content-Type: application/json' http://localhost:8545 | jq .
curl -X POST --data '{"jsonrpc":"2.0","method":"admin_peers","params":[],"id":1}' -H 'Content-Type: application/json' http://localhost:8545 | jq .
```

**Inspecting chain, block and transaction information**

```
eth.blockNumber
eth.getBlockByNumber(output of above).number
eth.getTransactionFromBlock(hex output from above)
```

```
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' -H 'Content-Type: application/json' http://localhost:8545 | jq .
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["hexresultfromabove", true],"id":1}' -H 'Content-Type: application/json' http://localhost:8545
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionByBlockNumberAndIndex","params":["<hexresult>", "<difficulty>"],"id":1}' -H 'Content-Type: application/json' http://localhost:8545
```

**Creating wallets / accounts and transferring Ether between accounts**

```
eth.accounts
###
Open another terminal and enter below command
geth account new
geth account list
###
eth.sendTransaction({
    from: eth.accounts[0],
    to: "0xaccountof new",
    value: web3.toWei(500.0, 'ether')
});
eth.getBalance('0xAccountnumber of new')
eth.getBalance(eth.acounts[0]);
```

```
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_accounts","params":[],"id":1}' -H 'Content-Type: application/json' http://localhost:8545 | jq .
###
Open another terminal and enter below command
geth account new
geth account list
###
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from": "0xc9c913c8c3c1cd416d80a0abf475db2062f161f6","to":"newaccountnumber","gas": "0x76c0","gasPrice": "0x0", "value": "0x1", "data": ""}],"id":1}' -H 'Content-Type: application/json' http://localhost:8545
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0xc9c913c8c3c1cd416d80a0abf475db2062f161f6", "latest"],"id":1}' -H 'Content-Type: application/json' http://localhost:8545
```

## dApp (UI and SmartContract) Development and Demo in Action

This is a simple Hello World Application