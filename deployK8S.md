### 
https://viblo.asia/p/bai-7-trien-khai-hyperledger-fabric-len-kubernetes-gGJ599xx5X2
https://github.com/feitnomore/hyperledger-fabric-kubernetes

###
1. devtool
- run file setupenv.sh
    + setup k8s env
    + pull img devtool-ui, -> run pod
    + pull img devtool-backend, mysql server -> run pod
    + pull img community
2. Create network, Setting up deployment
- apply deployment devtool-admin
- apply deployment:
    - Fabric CA
    - Fabric Orderer
    - Create Org1MSP Peer1 Deployment
    - Create Org2MSP Peer1 Deployment
    - Create Channel
    - Join channel
    - Install chaincode, Init chaincode
3. apply Fabric explorer, Fabric explorer db deployment.

