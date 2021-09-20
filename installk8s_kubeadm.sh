# Login as root just makes things easier
sudo su - 
# Update package sources
apt update
# install prereq tools 
apt install apt-transport-https ca-certificates curl software-properties-common
# add the google key to validate package source
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# add docker key to validate package source
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# update package source 
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
# update newly added source
apt update
# install kube resources
apt install -y kubelet kubeadm kubectl
# Add the docker fingerprint
apt-key fingerprint 0EBFCD88
add-apt-repository 'deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable'
# install docker
apt update
apt install docker-ce
#initialize new clluster
kubeadm initialize # this will return the JOIN TOKEN for subsequent steps
# add worker nodes, run on other machines
kubeadm join --token $JOIN_TOKEN $KUBE_Main_IP:6443
# where ever you will manage the cluster from run the following to get the config
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id: -g) $HOME/.kube/config 