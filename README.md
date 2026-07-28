# AZ-700 - Internal Azure Load Balancer Terraform.

## Overview

This project creates an Azure Load Balancer using **Terraform** instead of the Azure Portal.

The goal is to gain hands-on experience deploying Azure networking resources using Infrastructure as Code (IaC).

## Technologies

- VsCode
- Terraform
- Microsoft Azure
- Azure Resource Manager (AzureRM Provider)


## Resources Deployed

Current resources:

- Resource Group
- Virtual Network
- Backend Subnet
- Frontend Subnet
- Azure Bastion Subnet
- Azure Bastion Host
- Public IP for Bastion
- Network Security Group
- Windows Virtual Machines
- Internal Azure Load Balancer
- Backend Address Pool
- Health Probe
- Load Balancing Rule

Each of the above resources play a significant role in welcoming clients to a website.

## Architecture

First you create a resource group of course to hold all the dependent resources, think of it like a containter.
A virtual network or VNET is then created (Think of it like an office in the cloud-- crazy lol) thennnn comes in the Frontend subnet as well as the backend... It is what clients see, it is what they connect to.. I.e- The LoadBalancer.
The Backend subnet, backend pool is where the VMs live they server a purpose, which is to show what the client intends to see... they type in the LB's public IP on purpose of course, to see something. AKA a host. It servers a purpose.

    

## Learning Objectives

This project demonstrates how to:

- Deploy Azure infrastructure using Terraform
- Create and manage Azure networking resources
- Understand Terraform resource dependencies
- Use Infrastructure as Code instead of the Azure Portal
- Build an Internal Azure Load Balancer
- Understand the role a Load Balancer plays
- Secure virtual machines using Azure Bastion


## Project Structure

├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
├── .gitignore
└── README.md


---

## Deployment

Initialise Terraform

bash
terraform init

Validate the configuration

```bash
terraform validate
```

Preview the deployment

```bash
terraform plan
```

Deploy the infrastructure

```bash
terraform apply
```

---

## Notes

This repository is part of my Azure networking learning journey while studying for the **AZ-700: Designing and Implementing Microsoft Azure Networking Solutions** certification.

The project is being developed incrementally to better understand each Azure resource and how Terraform manages infrastructure.
