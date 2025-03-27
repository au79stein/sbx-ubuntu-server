#!/bin/bash
set -x

###################
# add docker user #
###################
useradd docker

# should be removed but makes my life simpler - don't require sudo passwd, like ubuntu user
echo 'docker ALL=(ALL) NOPASSWD:ALL' | EDITOR='tee -a' visudo

# add docker gpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# add repo and update
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update

# install docker-ce
apt-get install -y docker-ce

# add user to docker group
usermod -aG docker ubuntu

# pull nginx image

# run container with port mapping


##############################
# install kubectl for x86-64 #
##############################
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# download checksum
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

# validate binary against checksum
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

if [[ $? == 0 ]]; then 
	echo "checksum is good"
else
	echo "checksum is no good"
fi

# install kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

kubectl version --client --output=yaml

# apt-get update
# apt-get install -y ca-certificates curl
# curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
# echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# apt-get update
# apt-get intall -y kubectl



###############
# install k3d #
###############
apt-get -y install wget
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# create cluster
su ubuntu  -c '/usr/local/bin/k3d cluster create tkb --servers 1 --agents 3 --image rancher/k3s:latest'



###############
# install git #
###############
apt-get -y install git-all


################
# install helm #
################
su ubuntu -c 'curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash'


###################
# install golang: #
###################
su ubuntu -c 'cd ~ && curl -OL https://go.dev/dl/go1.24.1.linux-amd64.tar.gz'
su ubuntu -c 'sha256sum ~/go1.24.1.linux-amd64.tar.gz'
cd ~ubuntu && tar -C /usr/local -xvf go1.24.1.linux-amd64.tar.gz
su ubuntu -c 'echo "export PATH=$PATH:/usr/local/go/bin"  >> ~/.profile'
su ubuntu -c 'source ~/.profile'
su ubuntu -c 'go version'



################
# install java #
################
java -version
apt update
apt install -y default-jre
java_version=$(java -version)
echo "JAVA_VERSION: ${java_version}"



###############
# clone repos #
###############
su ubuntu -c 'mkdir /home/ubuntu/Repos'
su ubuntu -c 'cd /home/ubuntu/Repos && git clone https://github.com/au79stein/TheK8sBook.git'
su ubuntu -c 'cd /home/ubuntu/Repos && git clone https://github.com/au79stein/helm-test.git'

# temporary repositories to work with
#su ubuntu -c 'cd /home/ubuntu/Repos && git clone https://github.com/au79stein/go-web-scraper.git'



##############################
# install awscli on instance #
##############################
echo "installing awscli..."
apt install -y awscli



#################
# install unzip #
#################

echo "installing unzip..."
apt install -y unzip



##########################
# installing aws-sam-cli #
##########################
echo "downloading aws-sam-cli... and installing..."
su ubuntu -c 'wget -q https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip'
su ubuntu -c 'unzip aws-sam-cli-linux-x86_64.zip -d sam-installation'
su ubuntu -c 'sudo ./sam-installation/install'
su ubuntu -c '/usr/local/bin/sam --version'



#########################################################
# install net-tools (need it for testinging ports, etc) #
#########################################################
echo "installing net-tools (netstat, etch)..."
apt install -y net-tools



##############################
# install grafana-enterprise #
##############################
echo "getting grafana enterprise signing key..."
apt-get install -y apt-transport-https
apt-get install -y software-properties-common wget
wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key

echo "adding repo for stable releases..."
echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
apt-get update

# for tutorial we are using open source version

echo "installing grafana-enterprise..."
#apt-get install -y grafana-enterprise
apt-get install -y grafana

echo "starting services..."
systemctl daemon-reload

systemctl start grafana-server

systemctl status grafana-server

systemctl enable grafana-server.service


################
# install tree #
################
echo "installing tree utility..."
apt install -y tree
echo "tree was installed"


#################
# install nginx #
#################
echo "installing and configuring nginx..."
apt install -y nginx
nginx_version=`nginx -v`
echo "$nginx_version"

echo "stopping apache2 webserver..."
systemctl stop apache2

echo "starting nginx..."
systemctl start nginx

# setup nginx as reverse proxy
cd /etc/nginx/sites-enabled

cat << EOF > grafana.terrorgrump.com.conf
server {
        listen 80;
        listen [::]:80;
        server_name grafana.terrorgrump.com;

                location / {
                        proxy_pass      http://localhost:3000/;
                }
}
EOF

echo "checking nginx config..."
nginx -t

echo "starting nginx..."
service nginx start
systemctl start nginx

set +x
