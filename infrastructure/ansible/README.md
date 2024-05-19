# Ansible Playbooks for my Homelab

This repository contains the Ansible playbooks and roles I use to manage my homelab.
Specifically, I use these playbooks to manage "metal" which is the underlying infrastructure that runs my homelab.

## Playbooks

### `bootstrap-metal.yml`

This playbook starts a PXE Server on localhost with Docker and sends wake-up packet to the nodes for provisioning.

Example usage to bootstrap one node:

```bash
ansible-playbook -i inventory/hosts.yml bootstrap-metal.yml -l localhost,pve-node-04
```

### `provision-metal.yml`

This playbook does two things:

1. Prepare the nodes for Proxmox installation by doing host specific configurations.
2. Installs Proxmox on the nodes which uses [lae.proxmox)(https://github.com/lae/ansible-role-proxmox) role to configure Proxmox.

Example usage to provision one node:

```bash
ansible-playbook -i inventory/hosts.yml provision-metal.yml -l pve-node-01
```

## Ansible Vaults

The Ansible Vault password is stored in the `.vault-pass` file which is not checked into the repository.

## Ansible requirements

Install the required Ansible roles and collections:

```bash
ansible-galaxy install -r requirements.yml
```
