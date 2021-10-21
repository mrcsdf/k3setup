apt upgrade && apt update -y
curl -fsL https://get.docker.com | sh -
useradd -m -d /home/smrtrock/ -s /bin/bash -G sudo,root,docker smrtrock
passwd smrtrock