# IaC : Infrastructure as Code

# kubernetes master init (m-k8s)
kubeadm init --apiserver-advertise-address=192.168.63.100

# 시작하기
vagrant up [m-k8s|w1-k8s|w2-k8s] 

# 종료하기
vagrant halt -f [m-k8s|w1-k8s|w2-k8s] 

# SSH확인하기
vagrant ssh-config [m-k8s|w1-k8s|w2-k8s] 
