#!/bin/bash

step=1
step() {
    echo "Step $step $1"
    step=$((step+1))
}

resolve_dns() {
    step "===== Create symlink to /run/systemd/resolve/resolv.conf ====="
    sudo rm /etc/resolv.conf
    sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
}

install_docker() {
    step "===== Installing docker ====="
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    if [ $? -ne 0 ]; then
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    fi
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt update

    sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common 
    sudo apt -y install docker-ce docker-ce-cli containerd.io
    sudo groupadd docker
    sudo gpasswd -a $USER docker
    sudo chmod 777 /var/run/docker.sock
    # Add vagrant to docker group
    sudo groupadd docker
    sudo gpasswd -a vagrant docker
    # Setup docker daemon host
    # Read more about docker daemon https://docs.docker.com/engine/reference/commandline/dockerd/
    # sed -i 's/ExecStart=.*/ExecStart=\/usr\/bin\/dockerd -H unix:\/\/\/var\/run\/docker.sock -H tcp:\/\/192.168.121.210/g' /lib/systemd/system/docker.service
    # sudo systemctl daemon-reload
    # sudo systemctl restart docker
    sudo systemctl enable docker
}

install_openssh() {
    step "===== Installing openssh ====="
    sudo apt -y install openssh-server
    sudo systemctl enable ssh
}

install_kubernetes() {
    step "===== Install Kubernetes ====="
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update
    # apt -y install kubelet kubeadm kubectl
    # apt-mark hold kubelet kubeadm kubectl
}

install_tools() {
    step "===== Install Tools ====="
    # sudo apt install -y python-pip
    # pip install kafka --user
    # pip install kafka-python --user
    sudo apt -y install openjdk-8-jdk net-tools xterm tmux cowsay 
}

setup_ssh_login() {
    step "===== Install SSH login ====="
    sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    sudo systemctl restart ssh
}

setup_welcome_msg() {
    step "===== Install Welcome Message ====="
    sudo echo -e "\necho \"Welcome to Vagrant Ubuntu Server 20.04\" | cowsay\n" >> /home/vagrant/.bashrc
    sudo ln -s /usr/games/cowsay /usr/local/bin/cowsay
}

# repository mirror 변경으로 대체합니다.
# install_apt_axel() {
#    step "===== Install APT axel =====" 
#    sudo apt update
#    sudo apt install aria2
#    sudo add-apt-repository -y ppa:apt-fast/stable
#    sudo apt update
#    sudo DEBIAN_FRONTEND=noninteractive apt -y install apt-fast
# }

main() {
    resolve_dns
    install_docker
    install_kubernetes
    install_tools
    install_openssh
    setup_ssh_login
    setup_welcome_msg
}

main
