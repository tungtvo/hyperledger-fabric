#!/bin/bash

# Setup environment and download vBPE packages
# This script supports Linux based only. 
# For Windows users, checkout https://vBPE.io for more detail
# For support, please contact us at support@vBPE.io


banner() {
    echo "__      __  _____   ______   _______   _______   ______   _      "
    echo "\ \    / / |_   _| |  ____| |__   __| |__   __| |  ____| | |     "
    echo " \ \  / /    | |   | |__       | |       | |    | |__    | |     "
    echo "  \ \/ /     | |   |  __|      | |       | |    |  __|   | |     "
    echo "   \  /     _| |_  | |____     | |       | |    | |____  | |____ "
    echo "    \/     |_____| |______|    |_|       |_|    |______| |______|"
    echo ""
    echo "                   ____    _____    ______ "
    echo "                  |  _ \  |  __ \  |  ____|"
    echo " __   __  ______  | |_) | | |__) | | |__   "
    echo " \ \ / / |______| |  _ <  |  ___/  |  __|  "
    echo "  \ V /           | |_) | | |      | |____ "
    echo "   \_/            |____/  |_|      |______|"
}
                                                    
footer() {
    echo "                                                     "
    echo " _____ _   _    _    _   _ _  __ __   _____  _   _   "
    echo "|_   _| | | |  / \  | \ | | |/ / \ \ / / _ \| | | |  "
    echo "  | | | |_| | / _ \ |  \| | ' /   \ V / | | | | | |  "
    echo "  | | |  _  |/ ___ \| |\  | . \    | || |_| | |_| |  "
    echo "  |_| |_| |_/_/   \_\_| \_|_|\_\   |_| \___/ \___/   "
    echo "                                                     "
    
}

banner

check_os() {
    if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        OS=Debian
        VER=$(cat /etc/debian_version)
    elif [ -f /etc/SuSe-release ]; then
        # Older SuSE/etc.
        ...
    elif [ -f /etc/redhat-release ]; then
        # Older Red Hat, CentOS, etc.
        ...
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    echo $OS
}

check_docker() {
    command -v docker >& /dev/null
    NODOCKER=$?
    DOCKER=null
    if [ "${NODOCKER}" == 0 ]; then
        DOCKER=$(docker -v)
    fi
    echo ${DOCKER}
}

check_nodejs() {
    command -v node >& /dev/null
    NONODE=$?
    NODEJS=null
    if [ "${NONODE}" == 0 ]; then
        NODEJS=$(node -v)
    fi
    echo ${NODEJS}
}

OS=$(check_os)
# luongdv3
WORKING_DIR=${HOME}/.vBPE 

install_docker() {
    echo "============== INSTALL DOCKER, PLEASE WAIT =================="
    echo "Your OS system is $OS"
    echo ">>>>>> $password"
    if [ "$OS" = "Ubuntu" ]; then
        echo $password | sudo -S apt-get update
        echo $password | sudo -S apt-get install -y \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg-agent \
            software-properties-common
        
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        #TODO: check arch
        arch="amd64"
        echo $password | sudo -S add-apt-repository \
                "deb [arch=${arch}] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) \
                stable"
  
        echo $password | sudo -S apt-get update
        echo $password | sudo -S apt-get install -y docker-ce docker-ce-cli containerd.io
        
        echo $password | sudo groupadd docker
        echo $password | sudo gpasswd -a $USER docker
        newgrp docker
    
    elif [ "$OS" = "CentOS"]; then 
        echo "Docker automation installation on CentOS will be supported soon ..."
        echo "For the time being, please visit https://docs.docker.com/install/linux/docker-ce/centos/ to install docker"
    elif [ "$OS" = "Fedora" ]; then
        echo "Docker automation installation on Fedora will be supported soon ..."
        echo "For the time being, please visit https://docs.docker.com/install/linux/docker-ce/fedora/ to install docker"
    elif [ "$OS" = "Mac" ]; then
        echo "We do not support install Docker on MacOS through script right now. \
              Please follow this link to install https://docs.docker.com/docker-for-mac/install/"
    fi 
}

install_nodejs() {
    echo "============== INSTALL NODEJS, PLEASE WAIT =================="
    echo "Your OS system is $OS"
    echo ">>>>>> $password"
    if [ "$OS" = "Ubuntu" ]; then
        echo $password | sudo -S apt-get update
        echo $password | sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common build-essential unzip docker-compose
        
        curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
        echo $password | sudo apt-get install -y nodejs
  
    elif [ "$OS" = "CentOS"]; then 
        echo "Nodejs automation installation on CentOS will be supported soon ..."
        echo "Please follow this link to install https://nodejs.org/"
    elif [ "$OS" = "Fedora" ]; then
        echo "Nodejs automation installation on Fedora will be supported soon ..."
        echo "Please follow this link to install https://nodejs.org/"
    elif [ "$OS" = "Mac" ]; then
        echo "We do not support install Docker on MacOS through script right now. \
              Please follow this link to install https://nodejs.org/"
    fi 
}

echo "=================================================================="
echo "                      CHECKING ENVIRONMENT                        "
docker=$(check_docker)
nodejs=$(check_nodejs)
password=""

if [ "$docker" = "null" ] && [ "$nodejs" = "null" ]; then 
    echo "Docker and Nodejs are not installed on your system, would you like to install them now [y/n]: "
    read yesAll
    if [ "$yesAll" = "y" ]; then
        echo -n "Please enter your sudo password to continue: "
        read -s password;
        install_docker
        install_nodejs
    fi
elif [ "$docker" = "null" ]; then 
    echo "Docker is not installed on your system, would you like to install it now [y/n]: "
    read yesDocker
    if [ "$yesDocker" = "y" ]; then 
        echo -n "Please enter your sudo password to continue: "
        read -s password;
        install_docker
    fi
elif [ "$nodejs" = "null" ]; then
    echo "Nodejs is not installed on your system, would you like to install it now [y/n]: "
    read yesNodejs
    if [ "$yesNodejs" = "y" ]; then
        echo -n "Please enter your sudo password to continue: "
        read -s password;
        install_nodejs
    fi
else 
    echo "Congrat, your system meets requirements"
    echo "Nodejs version $nodejs"
    echo $docker
fi

#check nodejs and docker version again
docker=$(check_docker)
nodejs=$(check_nodejs)
if [ "$docker" = "null" ] | [ "$nodejs" = "null" ]; then 
    echo "Docker and Nodejs are not install on your system, Exit now ..."
    exit 1
fi

if [ "$1" = "start" ]; then
    echo "=================================================================="
    echo "                     START APPLICATION                            "
    #check if environment ready or not
    #checking mysql
    isMysql=$(docker ps | grep "devtool-mysql")
    isHealthy=$(docker ps | grep "healthy")
    if [ -z "$isMysql" ] && [ -z "$isHealthy" ]; then
        echo "MYSQL server is not ready, please start it manually by 'docker start mysql'"
        exit 1
    fi
    #check devtool admin
    # luongdv3
    isDevtoolAdmin=$(docker ps | grep "vbpe/devtool-admin")
    if [ -z "$isDevtoolAdmin" ]; then 
        echo "Devtool admin is not ready, please start it manualy by 'docker start admin'"
        exit 1
    fi 
    #check devtool-ui
    # luongdv3
    isFrontEnd=$(docker ps | grep "vbpe/devtool-ui")
     if [ -z "$isFrontEnd" ]; then 
        echo "Devtool front end is not ready, please start it manualy by 'docker start devtool-ui'"
        exit 1
    fi 

    if [ ! -d ${WORKING_DIR}/devtool-backend ]; then
        echo "Cannot find devtool backend"
        exit 1
    fi
    cd ${WORKING_DIR}/devtool-backend
    npm install 
    # yarn install --ignore-engines
    nohup node server.js > output_backend.log &
    echo "=================================================================="
    echo "Devtool is ready now, You can try it at http://localhost:4500"
    
    footer
fi

if [ "$1" = "reset" ] || [ -z "$1" ] ; then
    if [ -d ${WORKING_DIR} ]; then 
        if [ -z "$password" ]; then
            echo -n "Please enter your sudo password to continue: "
            read -s password;
        fi 
        echo $password | sudo rm -fr ${WORKING_DIR}
        if [ $? -ne 0 ]; then
            echo "Cannot delete old working data ${WORKING_DIR}, try delete it manually and then run script again"
            exit 1
        fi
    fi

    echo ""
    echo "=================================================================="
    echo "             LOADING vBPE PACKAGES, PLEASE WAIT ...            "

    mkdir ${WORKING_DIR}
    cd ${WORKING_DIR}

    #get vBPE backend, script using CURL or WGET or Git
    git clone https://v-bpe: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@github.com/v-bpe/devtool-backend.git
    git clone https://v-bpe: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@github.com/v-bpe/devtool-community-network.git

    echo "=================================================================="
    echo "Runing Mysql container"
    docker rm -f $(docker ps -a | grep devtool-mysql | awk '{print $1}')
    docker run -p 4406:3306 -d --restart always --name devtool-mysql -e MYSQL_ROOT_PASSWORD=vBPEPwd mysql/mysql-server:latest

    echo "Mysql started. It may take sereral munites for ready connection, please wait ..."
    while true;
    do
        isMysql=$(docker ps | grep "mysql")
        isHealthy=$(docker ps | grep "healthy")
        isUnHealthy=$(docker ps | grep "unhealthy")
        if [ ! -z "$isMysql" ] && [ ! -z "$isHealthy" ] && [ -z "$isUnHealthy" ]; then
            echo "Connection ready, start configuration"

            # docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'vBPEPwd'\""
            # docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION\""
            # docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"DROP USER 'root'@'localhost'\""
            # docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"FLUSH PRIVILEGES\""

            docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"UPDATE mysql.user SET Host='%' WHERE User='root' AND Host='localhost'\""
            docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"FLUSH PRIVILEGES\""
            docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"GRANT ALL PRIVILEGES ON * . * TO 'root'@'%'\""
            docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'vBPEPwd'\""

            echo "Configuration finish"
            break
        fi
        sleep 1
    done

    echo "=================================================================="
    echo "                  PREPARE FOR INSTALLING NETWORK                  "
    cd ${WORKING_DIR}/devtool-community-network
    git checkout master
    chmod +x ./runFabric.sh
    chmod +x ./scripts/*

    echo "=================================================================="
    echo "                      INSTALLING BACKEND SERVER                   "
    cd  ${WORKING_DIR}/devtool-backend
    git checkout master
    npm install
    # yarn install --ignore-engines
    nohup node server.js > output_backend.log &

    isDevtoolUI=$(docker ps -a | grep devtool-ui | awk '{print $1}')
    if [ ! -z "$isDevtoolUI" ]; then
        docker rm -f $(docker ps -a | grep devtool-ui | awk '{print $1}')
    fi
    docker pull vbpe/devtool-ui:1.0 && docker run -p 4500:80 -d --restart always --name vbpe-devtool-ui vbpe/devtool-ui:1.0

    echo ""
    echo "=================================================================="
    echo "Devtool is ready now, You can try it at http://localhost:4500"

    footer
fi

if [ "$1" = "clean-network" ]; then
    echo "=================================================================="
    echo "                         DEVTOOL - CLEAN NETWORK                            "

    docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"DELETE FROM devtoolcommdb.chaincode;\""
    docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"DELETE FROM devtoolcommdb.network;\""
    docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"FLUSH PRIVILEGES\""
    echo "clear network & chaincode ..."

    cd  ${WORKING_DIR}/devtool-community-network 
    # cd ../devtool-community-network
    
    chmod +x ./runFabric.sh
    chmod +x ./scripts/*

    ./runFabric.sh clean 

    isexited=$(docker ps -q -f status=exited| awk '{print $1}')
    if [ ! -z "$isexited" ]; then
        docker rm -f $(docker ps -q -f status=exited| awk '{print $1}')
    fi

    iscreated=$(docker ps -q -f status=created| awk '{print $1}')
    if [ ! -z "$iscreated" ]; then
        docker rm -f $(docker ps -q -f status=created| awk '{print $1}')
    fi
    
    
    

    echo "=================================================================="
    echo "cleaned!"
    
    footer
fi

if [ "$1" = "clean-chaincode" ]; then
    echo "=================================================================="
    echo "                         DEVTOOL - CLEAN CHAINCODE                            "

    docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"DELETE FROM devtoolcommdb.chaincode;\""
    docker exec -it devtool-mysql sh -c "mysql -uroot -pvBPEPwd -e \"FLUSH PRIVILEGES\""
    echo "cleaning chaincode ..."
    echo "=================================================================="
    echo "cleaned!"
    
    footer
fi


if [ "$1" = "clean-all" ]; then
    echo "=================================================================="
    echo "                         DEVTOOL - CLEAN ALL                            "
    cd  ${WORKING_DIR}/devtool-community-network 
    # cd ../devtool-community-network
    
    sudo chmod +x ./runFabric.sh
    chmod +x ./scripts/*

    ./runFabric.sh clean 

    isDevtoolUI=$(docker ps -a | grep devtool-ui | awk '{print $1}')
    if [ ! -z "$isDevtoolUI" ]; then
        echo ""
        docker rm -f $(docker ps -a | grep devtool-ui | awk '{print $1}')
    fi
    
    isDevtoolFrt=$(docker ps -a | grep devtool-frontend | awk '{print $1}')
    if [ ! -z "$isDevtoolFrt" ]; then
        docker rm -f $(docker ps -a | grep devtool-frontend | awk '{print $1}')
    fi
    isexited=$(docker ps -q -f status=exited| awk '{print $1}')
    if [ ! -z "$isexited" ]; then
        docker rm -f $(docker ps -q -f status=exited| awk '{print $1}')
    fi

    iscreated=$(docker ps -q -f status=created| awk '{print $1}')
    if [ ! -z "$iscreated" ]; then
        docker rm -f $(docker ps -q -f status=created| awk '{print $1}')
    fi

    ishyperledger=$(docker ps -a | grep hyperledger | awk '{print $1}')
    if [ ! -z "$ishyperledger" ]; then
    docker rm -f $(docker ps -a | grep hyperledger | awk '{print $1}')
    fi

    isakachain=$(docker ps -a | grep akachain | awk '{print $1}')
    if [ ! -z "$isakachain" ]; then
    docker rm -f $(docker ps -a | grep akachain | awk '{print $1}')
    fi

    isvbpe=$(docker ps -a | grep vbpe | awk '{print $1}')
    if [ ! -z "$isvbpe" ]; then
    docker rm -f $(docker ps -a | grep vbpe | awk '{print $1}')
    fi
    
    ismysql=$(docker ps -a | grep devtool-mysql | awk '{print $1}')
    if [ ! -z "$ismysql" ]; then
    docker rm -f $(docker ps -a | grep devtool-mysql | awk '{print $1}')
    fi

    ispeer=$(docker ps -a | grep peer | awk '{print $1}')
    if [ ! -z "$ispeer" ]; then
    docker rm -f $(docker ps -a | grep peer | awk '{print $1}')
    fi

    sudo kill -9 $(lsof -t -i tcp:44080)
    sudo rm -rf cd ${WORKING_DIR}/*

    echo "=================================================================="
    echo "removed!"
    
    footer
fi