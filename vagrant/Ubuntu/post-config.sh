#!/bin/bash

# ubuntu20.04 change grub : fix for too slow booting 
#sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT.*$/GRUB_CMDLINE_LINUX_DEFAULT=\"intremap=off quiet splash button.lid_init_state=open\"/' /etc/default/grub
#sudo update-grub

# microk8s에서 swap disable이 필요한가요?
# swapoff -a to disable swapping
# swapoff -a

# sed to comment the swap partition in /etc/fstab
# sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

# Letting iptables see bridge traffic
#cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
#net.bridge.bridge-nf-call-ip6tables = 1
#net.bridge.bridge-nf-call-iptables = 1
#EOF
#sudo sysctl --system

# ssh add key
sudo cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# user env
sudo cp /etc/bash.bash_aliases ~/.bash_aliases
