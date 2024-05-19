# Homelab monorepo

This project is in **ALPHA** stage and this repository serves as a monorepo for my homelab and it's operated using [gitops](https://www.gitops.tech/). This is a WIP project and should not be considered stable `¯\_(ツ)_/¯`

The goal is to have a homelab operated by gitops. This applies to infrastructure, platform and services running on the platform. I will be running OKD as my K8S platform on top of Proxmox hypervisors.

## Goals

The main goals are:

- A clustered Proxmox environment where I can deploy an OKD environment.
- Using Gitops for continuous deployment and self-documenting deployments.
- Easy and fast error recovery of services.

My personal goals are:

- Learn and understand how K8S works.
- Learn how to use gitops as a way to deploy and operate both hypervisors and services.

## Overview

OKD is the community version of OpenShift. It is a Kubernetes distribution with a lot of features on top of Kubernetes. [Installing a user-provisioned cluster on bare metal](https://docs.okd.io/latest/installing/installing_bare_metal/installing-bare-metal.html) serves as a guide for the installation of OKD on top of Proxmox hypervisors.

### Hardware

Proxmox Hypervisors consists of four (4) `Lenovo P330 ThinkStations`. Each node has the following specs:

- CPU: i7-8700t
- RAM: 64GB DDR4
- Storage: 250gb NVMe for OS and 2tb NVMe for storage
- Network: 1Gbe NIC (onboard). Will be upgraded to 10Gbit SFP+ NIC in the future.

### Networking

It is a simple network setup with a Mikrotik router. The network is segmented into two subnets. One for the hypervisors and one for the OKD platform.

- DNS: Pi-Hole + OKD Service node
- Router: Mikrotik
- IP-Subnet for hypervisors: 192.168.10.0/24
- IP-subnet for OKD platform: 192.168.11.0/24

### Proxmox Platform

The Proxmox hypervisors

| Proxmox Node | IP Address    | OS        |
| ------------ | ------------- | --------- |
| pve-node-01  | 192.168.10.15 | Debian 12 |
| pve-node-02  | 192.168.10.16 | Debian 12 |
| pve-node-03  | 192.168.10.17 | Debian 12 |
| pve-node-04  | 192.168.10.18 | Debian 12 |

### OKD Platform

OKD is deployed using the [platform-agnostic](https://docs.okd.io/latest/installing/installing_platform_agnostic/installing-platform-agnostic.html) installation method.

#### Sizing

OKD requires a minimum of 3 control-plane nodes and 2 compute nodes. Each node requires a minimum of 16GB of RAM and 4 vCPUs. This is the minimum requirement for a small cluster.

| VM Name              | Role                       | IP Address    | OS             | vCPU | RAM | Storage | Cluster-Node |
| -------------------- | -------------------------- | ------------- | -------------- | ---- | --- | ------- | ------------ |
| okd4-bootstrap       | bootstrap                  | 192.168.11.20 | Fedora Core OS | 4    | 16  | 120     | 1            |
| okd4-services-1      | DNS,<br>LB,<br>Web,<br>NFS | 192.168.11.21 | CentOS 9       | 4    | 4   | 100     | 2            |
| okd4-services-2      | DNS,<br>LB,<br>Web,<br>NFS | 192.168.11.22 | CentOS 9       | 4    | 4   | 100     | 4            |
| okd4-control-plane-1 | master                     | 192.168.11.30 | Fedora Core OS | 4    | 16  | 120     | 1            |
| okd4-control-plane-2 | master                     | 192.168.11.31 | Fedora Core OS | 4    | 16  | 120     | 3            |
| okd4-control-plane-3 | master                     | 192.168.11.32 | Fedora Core OS | 4    | 16  | 120     | 4            |
| okd4-compute-1       | worker                     | 192.168.11.33 | Fedora Core OS | 4    | 16  | 120     | 2            |
| okd4-compute-2       | worker                     | 192.168.11.34 | Fedora Core OS | 4    | 16  | 120     | 3            |

### Backup strategy

There are to types of backup strategy in place:

- ETCD - [gardener/tcd-backup-restore](https://github.com/gardener/etcd-backup-restore).
- Volumes - [Kasten K10](https://docs.kasten.io/latest/index.html)
