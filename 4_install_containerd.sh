#!/bin/bash

# Go get latest containerd release archive:
# https://github.com/containerd/containerd/releases

CONTAINERD_VERSION="1.6.6"
wget https://github.com/containerd/containerd/releases/download/v${CONTAINERD_VERSION}/containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz

# Untar it to /usr/local
tar Cxzvf /usr/local containerd-${CONTAINERD_VERSION}-linux-amd64.tar.gz

# Download containerd.service and put it in /usr/lib/systemd/system/containerd.service
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
mv containerd.service /usr/lib/systemd/system/containerd.service

# Launch systemd daemon for containerd
systemctl daemon-reload
systemctl enable --now containerd

# Go get runc archive
RUNC_VERSION="1.1.3"
wget https://github.com/opencontainers/runc/releases/download/v${RUNC_VERSION}/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc

# Install CNI plugins
CNI_PLUGINS_VERSION="1.1.1"
wget https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-linux-amd64-v${CNI_PLUGINS_VERSION}.tgz

# Extract under /opt/cni/bin
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v${CNI_PLUGINS_VERSION}.tgz

# Generate default daemon config file
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i "s/SystemdCgroup = false/SystemdCgroup = true/g" /etc/containerd/config.toml

# Create basic CNI config file in /etc/cni/net.d
cat << EOF | tee /etc/cni/net.d/10-containerd-net.conflist
{
  "cniVersion": "1.1.1",
  "name": "containerd-net",
  "plugins": [
    {
      "type": "bridge",
      "bridge": "cni0",
      "isGateway": true,
      "ipMasq": true,
      "promiscMode": true,
      "ipam": {
        "type": "host-local",
        "ranges": [
          [{
            "subnet": "10.88.0.0/16"
          }],
          [{
            "subnet": "2001:4860:4860::/64"
          }]
        ],
        "routes": [
          { "dst": "0.0.0.0/0" },
          { "dst": "::/0" }
        ]
      }
    },
    {
      "type": "portmap",
      "capabilities": {"portMappings": true}
    }
  ]
}
EOF

# Restart containerd with latest configs
sudo systemctl restart containerd
