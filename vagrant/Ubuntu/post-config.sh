#!/bin/bash

# ubuntu20.04 change grub : fix for too slow booting 
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT.*$/GRUB_CMDLINE_LINUX_DEFAULT=\"intremap=off quiet splash button.lid_init_state=open\"/' /etc/default/grub
sudo update-grub

# swapoff -a to disable swapping
swapoff -a
# sed to comment the swap partition in /etc/fstab
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

# ssh add key
sudo cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
