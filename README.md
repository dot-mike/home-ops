# Homelab monorepo

The monorepo for operating my homelab using [gitops](https://www.gitops.tech/). This is a WIP project and should not be considered stable `¯\_(ツ)_/¯`

## Goals

The main goals are:

* A clustered Proxmox environment where I can deploy an OKD environment.
* Using Gitops for continuous deployment and self-documenting deployments.
* Easy and fast error recovery of services.

My personal goals are:

* Learn how to use gitops as a way to deploy and operate both hypervisors and services.
* Learn and understand how K8S.
* Be able to deploy OKD both manually and automated.

## Overview

Project is in **ALPHA** stage. This repository is a monorepo for my homelab. The goal is to have a homelab operated by gitops. This applies to infrastructure, platform and services. I will be running OKD as my K8S platform on top of Proxmox.

### Hardware

Proxmox Hypervisors:

* 4x `Lenovo P330 TinyMicro`:
  * CPU: i7-8700t
  * RAM: 64GB DDR4
  * Storage: 250gb NVMe for OS and 2tb NVMe for storage
  * Network: 1Gbe NIC (onboard). Will be upgraded to 10Gbit SFP+ NIC in the future.

### Networking

* DNS: Pi-Hole + OKD Service node
* Router: Mikrotik
* IP-Subnet for hypervisors: 192.168.10.0/24
* IP-subnet for OKD platform: 192.168.11.0/24

### Proxmox Platform

Proxmox nodes are is automated using PXE-boot & Ansible

| Proxmox Node | IP Address    | OS         |
| ------------ | ------------- | ---------- |
| pve-node-01  | 192.168.10.15 | Debian 19  |
| pve-node-02  | 192.168.10.16 | Debian 19  |
| pve-node-03  | 192.168.10.17 | Debian 19  |
| pve-node-04  | 192.168.10.18 | Debian 19  |

### OKD Infra + platform

OKD is deployed using the [platform-agnostic](https://docs.okd.io/4.13/installing/installing_platform_agnostic/installing-platform-agnostic.html) installation method. The following table is based on the requirements from the OKD 4.13.

| VM Name              | Role                                      | IP Address    | OS             | vCPU | RAM | Storage | Cluster-Node |
| -------------------- | ----------------------------------------- | ------------- | -------------- | ---- | --- | ------- | ------------ |
| okd4-bootstrap       | bootstrap                                 | 192.168.11.20 | Fedora Core OS | 4    | 16  | 120     | 1            |
| okd4-services-1      | DNS,<br>LB,<br>Web,<br>NFS                | 192.168.11.21 | CentOS 9       | 4    | 4   | 100     | 2            |
| okd4-services-2      | DNS,<br>LB,<br>Web,<br>NFS                | 192.168.11.22 | CentOS 9       | 4    | 4   | 100     | 4            |
| okd4-control-plane-1 | master                                    | 192.168.11.30 | Fedora Core OS | 4    | 16  | 120     | 1            |
| okd4-control-plane-2 | master                                    | 192.168.11.31 | Fedora Core OS | 4    | 16  | 120     | 3            |
| okd4-control-plane-3 | master                                    | 192.168.11.32 | Fedora Core OS | 4    | 16  | 120     | 4            |
| okd4-compute-1       | worker                                    | 192.168.11.33 | Fedora Core OS | 4    | 16  | 120     | 2            |
| okd4-compute-2       | worker                                    | 192.168.11.34 | Fedora Core OS | 4    | 16  | 120     | 3            |

### Backup strategy

There are to types of backup strategy in place:

* ETCD - [gardener/tcd-backup-restore](https://github.com/gardener/etcd-backup-restore).
* Volumes - [Kasten K10](https://docs.kasten.io/latest/index.html)
