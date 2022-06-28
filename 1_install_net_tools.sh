#!/bin/bash

# Turn off swap
swapoff -a

# Install socat and conntrack-tools
zypper install socat conntrack-tools
