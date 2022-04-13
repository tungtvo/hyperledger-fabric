#!/bin/bash

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


# install_k8s
check_k8s() {
    command -v kubectl >& /dev/null # check kubectl installed or not
    NOK8S=$?
    K8S=null
    if [ "${NOK8S}" == 0 ]; then
        K8S=$(kubectl version)
    fi
    echo ${K8S}
}

# https://phoenixnap.com/kb/install-kubernetes-on-ubuntu
install_k8s() {
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    kubectl version --client
}

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

    echo "=================================================================="
    echo "Runing Mysql container"
    # docker rm -f $(docker ps -a | grep devtool-mysql | awk '{print $1}')
    # docker run -p 4406:3306 -d --restart always --name devtool-mysql -e MYSQL_ROOT_PASSWORD=vBPEPwd mysql/mysql-server:latest
    # https://phoenixnap.com/kb/kubernetes-mysql
    kubectl apply -f mysql-storage.yaml
    # run deployment mysql-server
    kubectl apply -f mysql-deployment.yaml

    echo "Mysql started. It may take sereral munites for ready connection, please wait ..."
    while true;
    do
        isMysql=$(docker ps | grep "mysql")
        isHealthy=$(docker ps | grep "healthy")
        isUnHealthy=$(docker ps | grep "unhealthy")
        if [ ! -z "$isMysql" ] && [ ! -z "$isHealthy" ] && [ -z "$isUnHealthy" ]; then
            echo "Connection ready, start configuration"

            kubectl exec -it mysql-server -- sh -c "mysql -uroot -pvBPEPwd -e \"UPDATE mysql.user SET Host='%' WHERE User='root' AND Host='localhost'\""
            kubectl exec -it mysql-server -- sh -c "mysql -uroot -pvBPEPwd -e \"FLUSH PRIVILEGES\""
            kubectl exec -it mysql-server -- sh -c "mysql -uroot -pvBPEPwd -e \"GRANT ALL PRIVILEGES ON * . * TO 'root'@'%'\""
            kubectl exec -it mysql-server -- sh -c "mysql -uroot -pvBPEPwd -e \"ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'vBPEPwd'\""

            echo "Configuration finish"
            break
        fi
        sleep 1
    done



    echo "=================================================================="
    echo "                      INSTALLING BACKEND SERVER                   "
    # run deployment backend
    kubectl apply -f devtool-backend-deployment.yaml
    kubectl apply -f devtool-backend-svc.yml
    # run deployment frontend
    kubectl apply -f devtool-ui-deployment.yaml
    sleep 5
    
    # Create persistent

    echo ""
    echo "=================================================================="
    echo "Devtool is ready now, You can try it at http://localhost:4500"

    footer
fi

# WORKING_DIR=${HOME}/k8s
# cd ${WORKING_DIR}
# OS=$(check_os)
# echo "Your OS system is $OS"
# echo "Your kubenetes version is $K8S"


# backend execute script sh -> mount folder sh 
# Backend upload chain code -> save file at devtool-backend/chaincode
