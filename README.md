This has been ran on VM with at least 2cores and Ubuntu Server 22.04 (Jammy Jellyfish) 

### Provisioning k8s-master

Below assumes that SSH is running and keys are imported etc.

Sources:
- https://www.linuxtechi.com/install-kubernetes-on-ubuntu-22-04/



```bash
apt-get install vim
```


1. QEMU agent

```bash
apt update && apt -y install qemu-guest-agent
systemctl enable qemu-guest-agent
systemctl start qemu-guest-agent
systemctl status qemu-guest-agent
```

2. Hostname

```bash
hostnamectl set-hostname "k8s-master.lab.donat.im"
```

3. Disable SWAP + modules

```bash
swapoff -a
sed -i '/swap/s/^/#/' /etc/fstab
```

```bash
tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter
```

4. Kube params

```bash
tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF 
```

```bash
sysctl --system
```

5. Containerd

```bash
apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y containerd.io
```

```bash
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
```

```bash
systemctl restart containerd
systemctl enable containerd
systemctl status containerd
```

6. Kubernetes

```bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
apt-add-repository -y "deb http://apt.kubernetes.io/ kubernetes-xenial main"
```

```bash
apt update
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
```

```bash
kubeadm init --control-plane-endpoint=k8s-master.lab.donat.im
```
