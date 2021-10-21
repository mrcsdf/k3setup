# https://www.jericdy.com/blog/installing-k3s-with-longhorn-and-usb-storage-on-raspberry-pi
# On master node if you want to use port forwarding from router
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san 192.168.86.39 --" sh - 
# Otherwise 
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="0644" INSTALL_K3S_EXEC="--no-deploy traefik --no-deploy kubernetes-dashboard" sh -
# get token 
sudo cat /var/lib/rancher/k3s/server/node-token

# On worker nodes
 curl -sfL https://get.k3s.io | K3S_URL=https://10.0.0.1:6443 K3S_TOKEN=K105d097fd97bb426ae41f2c523cc1287ec95c92193d22a25b21f762647b3e4da50::server:c746466ae891d877693f702372f5ad24 sh -

# copy the kubeconfig from master
sudo cat /etc/rancher/k3s/k3s.yaml


 # master node
 export K3S_KUBECONFIG_MODE="0644"
 export INSTALL_K3S_EXEC="server --node-taint CriticalAddonsOnly=true:NoExecute --tls-san 192.168.86.39 --no-deploy traefik --no-deploy kubernetes-dashboard"
 export K3S_DATASTORE_ENDPOINT='mysql://myadmin:LKFern13!#@tcp(192.168.86.39:3306)/k3s)'
 curl -fsL https://get.k3s.io/ | sh -

# nodes
 export K3S_TOKEN='...'
 export K3S_URL='https://10.0.0.244:6443'
 curl -fsL https://get.k3s.io/ | sh -

