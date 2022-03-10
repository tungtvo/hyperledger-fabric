# Pull required tools & Frontend
Run `devtool/setupEnv` or `./setupEnv.sh reset` first to check and install dependencies on Ubuntu
Start again (after PC reset, program terminated ...) `./setupEnv.sh start`
### Check Environment
Docker version > 17.x
Nodejs version > 8.x

### Loading akachain packages

- Clone devtool-backend
- Clone devtool-community-network
- pull & start mysql server (port 4406)
- Config mysql user (root/Akachain)

### pull docker images
- mysql-server

### Prepare for Installing network
- cd devtool-community-network
- chmod +x ./runFabric.sh
- chmod +x ./scripts/*

### Install backend server
Install & run backend:
- cd devtool-backend
- npm install
- nohup node server.js > output_backend.log &

Pull & run frontend (Port 4500)

# Create network
cd devtool-community-network and download fabric img:
```
- Hyperledger/fabric-peer
- Hyperledger/fabric-ca
- Hyperledger/fabric-ccenv
- Hyperledger/fabric-tools
- Hyperledger/fabric-couchdb
- Hyperledger/fabric-kafka
- Hyperledger/fabric-zookeeper
```

Cleaning orphan container.
Parameter config is created in `/scripts/env.sh` and `.env` (181)
Run cryptogen in docker-compose-generateCert to create CA (212)
Create Organization artifact in `artifact/cripto-config/peerOrganizations/` (224)
Download devtool-admin image in `docker-compose-network.yaml` and run network with Org1,Org2, orderer... with params have been set on `.env`


---
# Error
```
1. Cannot connect to mysql
Create user root/Akachain manually on mysql server
2. 
```



