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
<br/>

## vars / Arguments Reference
The following vars / arguments  parameters are expected : terraform variables are declared in vars.tf, and defined in terraform.tfvars

Name | Type      | Description
-----|-----------|------------
ak | string | The access key of the FlexibleEngine cloud
sk | string | The secret key of the FlexibleEngine cloud
domain_name | string | The Name of the Domain to scope to
tenant_name | string | The Name of the Project to login with
region | string | Region of the FlexibleEngine cloud
availability_zone_names | List | Availability zone of resource
cidr_vpc | string | The VPC CIDR of the main VPC
cidr_subnet_in | String | the input subnet that will hold our FE resources
cidr_subnet_out | String | the output subnet that will be exposed to public network and On-Perm via EIP
cidr_private_vpc | string | The VPC CIDR of the private VPC
cidr_private_subnet | String | the private subnet that will hold our FE resources
gateway_in | string | The gateway ip address of input subnet
gateway_out | string | The gateway ip address of output subnet
private_gateway | string | The gateway ip address of private subnet

## Output / Attributes Reference
The following attributes / output parameters are produced : terraform output variables res defined in outputs.tf

Name | Description
-----|------------
ip_firewall_in | Firewall ip address of network interface card attached to input subnet
ip_firewall_out | Firewall ip address of network interface card attached to output subnet
<br/>

## Diagram:
![Alt text](https://github.com/FlexibleEngineCloud/FE-landingzone/blob/main/docs/designs/north-south-multivpc.png)
