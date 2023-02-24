# Multi VPC North-South Filtering:
This is a guide to implementing a multi VPC North-South Filtering for your Flexible Engine (FE) infrastructure. by controlling traffic flow between your On-Premise and your FE infrastructure.
<br/>
This architecture uses an open source firewall (pfsense) deployed on an ECS instance using an pre-built IMS image, allowing only authorized traffic to enter and leave the LAN/Private network on FE infastructure. 
<br/>
This documentation will provide an overview of this architecture and its components.


## Components:
The Multi VPC North-South filtering via a firewall architecture consists of the following components:

- Virtual Private Cloud (VPC): A VPC is a logically isolated virtual network within the FE (Flexible Engine) Cloud. It provides a secure and scalable environment for resources to run within.

- Subnets: Subnets are logical partitions within a VPC that allow resources to be deployed in different network segments.

- Security Groups: Security groups act as virtual firewalls that control inbound and outbound traffic to instances associated with them.

- EIP: a public IPv4 address assigned to an EC2 instance (Firewall) to allow for internet connectivity.

- VPC Peering: a VPC peering connection between two VPCs that enables to route traffic.

## Architecture:
The architecture consists of the following steps:

- Create a VPC with multiple subnets, one for inbound traffic and the other for outbound traffic.

- Create the private VPC.

- Create a VPC peering between private VPC and firewall VPC, if the peer VPC is your own no need to accept the peering.
For cross-tenant VPCs you must accept the peering.

- Create an RSA keypair for logging and securing access to the ECS instance.

- Create security groups for the resources in the VPC to control inbound and outbound traffic to the resources.

- Create an ECS firewall instance, with two NICs, one attached to inbound subnet, and the other to the outbound subnet.
> Please make sure to disable manually "source destination check" on both NICs of the firewall.
<br/>

- Create an EIP public ip address and attach it to the outbound NIC interface on the firewall.

- Create routes on the VPC route tables to redirect inbound/outbound traffic.

- Configure the firewall ECS instance to allow only authorized traffic to enter and leave the VPC based on predetermined security rules.

## Diagram:
![Alt text](diagram.png)
