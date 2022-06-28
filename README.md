# k8s-install

This repo contains scripts for installing Kubernetes' kubeadm, kubectl, and kubelet in a production OpenSUSE environment using containerd as the container runtime.

- OS: OpenSUSE Leap 15.3
- Kubernetes Version - v1.24.2

## Usage

Execute them in their numbered order:
```
chmod +x *.sh
./1_install_net_tools.sh
./2_open_ports.sh
./3_forward_ipv4_traffic.sh
./4_install_containerd.sh
./5_install_kubeadm.sh
```
