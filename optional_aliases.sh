# download a python script for over 500 k8 shortcuts
curl https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/generate_aliases.py -o generate_aliases.py
curl https://raw.githubusercontent.com/ahmetb/kubectl-aliases/master/license_header -o license_header
# generate the k8 aliases
python3 generate_aliases.py > .kubectl_aliases

# download docker aliases 
curl https://gist.githubusercontent.com/jgrodziski/9ed4a17709baad10dbcd4530b60dfcbb/raw/d84ef1741c59e7ab07fb055a70df1830584c6c18/docker-aliases.sh -o .docker_aliases

# update the shell profile
sudo nano .bashrc
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
[ -f ~/.docker_aliases ] && source ~/.docker_aliases