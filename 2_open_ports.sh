#!/bin/bash

firewall-cmd --add-port=6443/tcp --permanent
firewall-cmd --add-port=2379/tcp --permanent
firewall-cmd --add-port=2380/tcp --permanent
firewall-cmd --add-port=10250/tcp --permanent
firewall-cmd --add-port=10248/tcp --permanent
firewall-cmd --add-port=10249/tcp --permanent
firewall-cmd --add-port=10259/tcp --permanent
firewall-cmd --add-port=10257/tcp --permanent
