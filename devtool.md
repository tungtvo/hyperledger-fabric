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

1. Cannot connect to mysql
`Create user root/Akachain manually on mysql server`
2. npm install devtool-backend: fatal error: zlib.h: No such file or directory
`sudo apt-get install libz-dev`
3. Run `node server.js`: ER_NOT_SUPPORTED_AUTH_MODE: Client does not support authentication protocol requested by server; consider upgrading MySQL client
`ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'Akachain';`
4. Create network error:
[ERROR] network - register org 1 failed:  { Error: connect ETIMEDOUT 0.0.12.56:80
    at TCPConnectWrap.afterConnect [as oncomplete] (net.js:1107:14)
`loi proxy, chua fix duoc`
5. docker-compose: command not found
Ho???c: PermissionError: [Erno 13] Permission denied: './.env'
`Install docker-compose (do not install snap version)`


