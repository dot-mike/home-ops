# Homelab monorepo

The ultimate monorepo for operating my homelab using [gitops](https://www.gitops.tech/). This is a WIP and should not be consired as stable nor prodcution ready ¯\_(ツ)_/¯


## Goals

The main goal is to have the homelab stored as code in git and managed by git. This applies infrastructure, platform and services.

I will be running OKD as my K8S platform on top of Proxmox.

### Platform

* A clustered environment running Proxmox which I can deploy services on using K8S.
* Using Gitops for continuous deployment and self-documenting deployments.
* Easy and fast error recovery

### Personal

* Learn how to use gitops as a way to deploy and operate both hypervisor and services
* Learn and understand how K8S works

## Hardware

Proxmox Hypervisors: 4x Lenovo P330 TinyMicro with i7-8700t + 64gb ram + 2tb SSD for storage
Network: Pi-Hole (DNS) + Mikrotik (Router)

## Networking

I'm using DHCP with MAC-reservation for handling networking. DNS is handled by Pi-Hole..

IP-Subnet for hypervisors: 192.168.11.0/24
IP-subnet for K8S: 192.168.12.0/24

### DNS Zones

