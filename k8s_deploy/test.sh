#!/bin/bash

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

echo current folder $PWD
# downloadFabricImages