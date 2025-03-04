# homelab-k8s-template

Repository containing a Terraform skeleton template for my homelab Kubernetes clusters.

## Table of Contents

- [Homelab K8s template](#homelab-k8s-template)
- [Table of Contents](#table-of-contents)
- [Description](#description)
  - [Limitations and decisions](#limitations-and-decisions)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Future ideas](#future-ideas)

## Description

This repository is used as a Terraform / OpenTofu template repository for my Talos Kubernetes clusters, allowing for simple create, destroy and re-create of Talos clusters.

Since I am planning to only use this template for my own homelab, which has it's own limitations, I made a few (hardcoded) decisions.

### Limitations and decisions

Ideally I would request an IP address by a hostname from a IP management system / database. If it does not yet exist, it should register the next free IP address in the pool of the given subnet. However, my homelab does not yet have such a system. Setting it up is outside of what I started this project for.

Relying on (Terraform) code to generate IP addresses is possible, but during testing I found one too many edge cases. The most simple example: add a control plane node and all the worker nodes shift up one IP address number.

Therefore:

* Prior to building the cluster IP addresses and MAC addresses should be registered in DHCP
* The first IP address is passed as a variable and assigned to the first control plane node for predictability and simplicity
* Controller count has been hardcoded to 3 for the exact same reason

This allows for flexibility in IP addresses / subnets and the amount of worker nodes, but keep things plain and simple.

I briefly considered `map` or `object` types to build up the individual nodes in a variable structure. For now I chose to give all the control plane and all the worker nodes the same configuration. Each worker nodes gets an additional "data" disk, which will be used for persistent storage using Rook Ceph.

## prerequisites

* A libvirt Qemu / KVM host
* Static DHCP reservation for the nodes
* A bridge interface "br20"
* Talos installation ISO available to be mounted by libvirt
* Terraform state file in an Azure storage account

## Usage

```bash
tofu init
tofu plan -out k8s-cls[x].plan
tofu apply k8s-cls[x].plan
tofu output -raw kubeconfig > ~/.kube/config && tofu output -raw talosconfig > ~/.talos/config
```

## Future ideas

- Implement a IP management system and fetch free / registered IPs by hostname
- Build nodes in a `map` or `object` type structure
- GitOps cluster configuration: utilize argo or flux for workload deployments
- See to make hardcoded libvirt uri variable

