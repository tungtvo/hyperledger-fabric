#!/bin/bash


# UTOP Network
TIMEOUT=45
# Banner
function banner() {
  echo "__      __  _____   ______   _______   _______   ______   _      "
  echo "\ \    / / |_   _| |  ____| |__   __| |__   __| |  ____| | |     "
  echo " \ \  / /    | |   | |__       | |       | |    | |__    | |     "
  echo "  \ \/ /     | |   |  __|      | |       | |    |  __|   | |     "
  echo "   \  /     _| |_  | |____     | |       | |    | |____  | |____ "
  echo "    \/     |_____| |______|    |_|       |_|    |______| |______|"
  echo ""
  echo "                           ____    _____    ______ "
  echo "                          |  _ \  |  __ \  |  ____|"
  echo "         __   __  ______  | |_) | | |__) | | |__   "
  echo "         \ \ / / |______| |  _ <  |  ___/  |  __|  "
  echo "          \ V /           | |_) | | |      | |____ "
  echo "           \_/            |____/  |_|      |______|"
  echo ""
  echo "                          loading..."
  echo ""
  sleep 1
}

# Print the usage message
function printHelp () {
  echo "Usage: "
  echo "  runFabric.sh clean|generate|run|app"
  echo "  runFabric.sh -h (print this message)"
  echo "    <clean> - clean docker ps and remove old certificate "
  echo "    <generate> - enerate certificate "
  echo "    <start> - start network"
  echo "    <stop> - stop & remove docker images in this machine"
  echo
}

function downloadFabricImages(){
	FABRIC_TAG=1.4.1
	IMAGES_CTR=$(docker images | grep ${FABRIC_TAG} | wc -l)
	IMAGE_ARRAY=(peer orderer ca ccenv tools)
	if [ $IMAGES_CTR -lt ${#IMAGE_ARRAY[*]} ]; then
		echo "============== Downloading Fabric Images =============="
		for image in ${IMAGE_ARRAY[*]}
		do
            docker pull hyperledger/fabric-$image:$FABRIC_TAG
            docker tag hyperledger/fabric-$image:$FABRIC_TAG hyperledger/fabric-$image
        done
	fi
	THIRDPARTY_TAG=0.4.15
	IMAGES_CTR=$(docker images | grep "kafka\|zookeeper\|couchdb" | grep ${THIRDPARTY_TAG} | wc -l)
	IMAGE_ARRAY=(couchdb kafka zookeeper)
	if [ $IMAGES_CTR -lt ${#IMAGE_ARRAY[*]} ]; then
		echo "============== Downloading Thirdparty Images =============="
		for image in ${IMAGE_ARRAY[*]}
		do
            docker pull hyperledger/fabric-$image:$THIRDPARTY_TAG
            docker tag hyperledger/fabric-$image:$THIRDPARTY_TAG hyperledger/fabric-$image
        done
	fi
}

function generate () {
  docker-compose -f docker-compose-generateCert.yaml up
}

function clean () {
  clearContainers
  for file in $(find . -name "fabric-client-kv-*");
  do
    echo $file;
    dir=$(dirname $file);
    echo ${dir};
    rm -rf ${dir}/fabric-client-kv-*;
  done
  rm -rf artifacts/*

  for file in $(find . -name "configtx.*");
  do
    echo $file;
    dir=$(dirname $file);
    echo ${dir};
    rm -rf ${dir}/configtx.*;
  done

  for file in $(find . -name "cryptogen.*");
  do
    echo $file;
    dir=$(dirname $file);
    echo ${dir};
    rm -rf ${dir}/cryptogen.*;
  done

  for file in $(find . -name "network-config.*");
  do
    echo $file;
    dir=$(dirname $file);
    echo ${dir};
    rm -rf ${dir}/network-config.*;
  done

  if [ -d "artifacts/channel-artifacts" ]; then
    echo "Removing old channel artifacts..."
    rm -rf artifacts/channel-artifacts
  fi
  if [ -d "artifacts/crypto-config" ]; then
    echo "Removing old crypto config..."
    rm -rf artifacts/crypto-config
  fi
  echo $PWD
}

function testSingleHost () {
  echo current folder $PWD
  downloadFabricImages
  ARCH=`uname -s | grep Darwin`
  if [ "$ARCH" == "Darwin" ]; then
    OPTS="-it"
  else
    OPTS="-i"
  fi
  echo "CLEANING..."
  echo $PWD
  ROOT_FOLDER=$PWD
  sleep 0.5s
  clean
  sleep 0.5s

  #### CONFIG #####

  rm ./scripts/env.sh
  touch ./scripts/env.sh
  echo "CHANNEL_NAME=($1)" >> ./scripts/env.sh
  echo "TOTALORG=2" >> ./scripts/env.sh
  echo "ORGNAMES=($2 $3)" >> ./scripts/env.sh
  echo "ORGDOMAINS=($2 $3)" >> ./scripts/env.sh
  echo "ORGMSPS=("$2MSP" "$3MSP")" >> ./scripts/env.sh
  echo "FABRICVER=$4" >> ./scripts/env.sh
  echo "CAPORTS=('7054' '8054')" >> ./scripts/env.sh
  echo "PEER0_DB_PORT_ORG=('5984' '6984')" >> ./scripts/env.sh
  echo "PEER1_DB_PORT_ORG=('7984' '8984')" >> ./scripts/env.sh
  echo "PEER0_PORT0_ORG=('7051' '8051')" >> ./scripts/env.sh
  echo "PEER0_PORT1_ORG=('7053' '8053')" >> ./scripts/env.sh
  echo "PEER1_PORT0_ORG=('7056' '8056')" >> ./scripts/env.sh
  echo "PEER1_PORT1_ORG=('7058' '8058')" >> ./scripts/env.sh
  echo "APP_IP=('localhost')" >> ./scripts/env.sh
  echo "TLS_ENABLED=true" >> ./scripts/env.sh
  echo "NETWORKNAME=$5" >> ./scripts/env.sh
  #### END-CONFIG ####
  source ./scripts/env.sh
  
  rm -f .env
  touch .env
  echo "NETWORK_NAME=${NETWORKNAME}" >> .env
  echo "IMAGE_TAG=${FABRICVER}" >> .env

  echo "GENERATING..."
  echo $PWD
  sleep 0.5s
  generate
  # docker-compose -f docker-compose-generateCert.yaml up
  sleep 0.5s

  
  echo "DB_IMAGE_TAG=0.4.15" >> .env
  echo "ORGNAMES1=${ORGNAMES[0]}" >> .env
  echo "ORGDOMAINS1=${ORGDOMAINS[0]}" >> .env
  echo "ORGNAMES2=${ORGNAMES[1]}" >> .env
  echo "ORGDOMAINS2=${ORGDOMAINS[1]}" >> .env
  echo "TLS_ENABLED=true" >> .env

  cd artifacts/crypto-config/peerOrganizations/$(echo ${ORGDOMAINS[0]})/ca/
  PRIV_ORG_KEY=$(ls *_sk)
  cd $ROOT_FOLDER
  echo "PRIV_ORG1_KEY=${PRIV_ORG_KEY}" >> .env

  cd artifacts/crypto-config/peerOrganizations/$(echo ${ORGDOMAINS[1]})/ca/
  PRIV_ORG_KEY=$(ls *_sk)
  cd $ROOT_FOLDER
  echo "PRIV_ORG2_KEY=${PRIV_ORG_KEY}" >> .env
  
  docker-compose -f docker-compose-network.yaml up -d

  sleep 10s

  docker-compose -f docker-compose-configCA.yaml up -d

  echo starting akachain explorer..
  docker-compose -f docker-compose-explorer-db.yaml pull
  docker-compose -f docker-compose-explorer.yaml pull

  docker-compose -f docker-compose-explorer-db.yaml up -d
  sleep 2s
  # docker exec explorer-db sh -c "createdb -h localhost -p 5432 -U postgres fabricexplorer"
  docker exec explorer-db /bin/bash /opt/createdb_new.sh
  # docker exec -it explorer-db sh -c "createdb -h localhost -p 5432 -U postgres fabricexplorer"
  docker-compose -f docker-compose-explorer.yaml up -d

}




if [ "$1" = "-h" ];then	
    printHelp
fi

MODE=$1
if [ "${MODE}" == "clean" ]; then 
  if [ ! -z "$2" ]
  then
    echo "cd to $2"
    cd $2
  fi
  clean
elif [ "${MODE}" == "stop" ]; then 
  stop
elif [ "${MODE}" == "startSingle" ]; then 
  banner
  if [ ! -z "$7" ]
  then
    echo "cd to $7"
    cd $7
  fi
  testSingleHost $2 $3 $4 $5 $6
else
  printHelp
  exit 1
fi


# 1. Apply fabric tool
# 2. Apply devtool-admin
# 3. ca.org1, ca.org2, 
# orderer0.orderer
# peer0.org1
# peer0.org1-db
# peer1.org1
# peer1.org1-db
# peer0.org2
# peer0.org2-db
# peer1.org2
# peer1.org2-db
# 4. Explorer