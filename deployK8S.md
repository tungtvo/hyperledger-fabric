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


###
|       Service | local  | docker| K8S    |
|   ----------- |  ---   | ---   |   ---  |
|devtool-ui     | 80     | 4500  | 30002  |
|mysql          | 3306   | 4406  |30006   |
|backend        | 44080  |       |  30003 |
|admin          | 30004  |       |        |
|explorer       | 8080   | 48080 | 30010  |
|explorer db    | 5432   | 55432 | 30011  |

