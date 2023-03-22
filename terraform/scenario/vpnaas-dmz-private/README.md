# VPNaaS DMZ/Private in MultiRegion :
This is a guide to implementing a VPNaaS architecture with DMZ/Private in multi region environment (eu-west-0/eu-west-1). by controlling traffic flow between public network and your FE infrastructure in multi region.
<br/>
This architecture uses an open source firewall (pfsense) deployed on an ECS instance using an pre-built IMS image, allowing only authorized traffic to enter and leave the DMZ/Private network on FE infastructure. 
<br/>
This documentation will provide an overview of this architecture and its components.
> [Virtual Private Network VPN Service](https://docs.prod-cloud-ocb.orange-business.com/usermanual/vpn/en-us_topic_0035391332.html) on FlexibleEngine at now, is not supported yet for terraform deployment. The creation of VPN gateway on the second region (Paris) is done manually via console, as well as the tunnel establishement between the AMSTERDAM region from ECS instance firewall to the PARIS region VPN gateway. 


## Components:
The VPNaaS DMZ/Private architecture consists of the following components:

- Virtual Private Cloud (VPC): A VPC is a logically isolated virtual network within the FE (Flexible Engine) Cloud. It provides a secure and scalable environment for resources to run within.

- Subnets: Subnets are logical partitions within a VPC that allow resources to be deployed in different network segments.

- Security Groups: Security groups act as virtual firewalls that control inbound and outbound traffic to instances associated with them.

- EIP: a public IPv4 address assigned to the virtualIP to allow for internet connectivity.

- VPC Peering: a VPC peering connection between VPCs that enables to route traffic.

- VirtualIP: Virtual IP address for high availability attached on multiple firewalls.

- AutoScaling Group: Automatically adjusts ECS server capacity based on traffic load.

- NetworkACL: Network Access Control List for controling traffic on subnets.

- RDS: Relational Database Service for data storage.

- VPN : VPN Tunnel between PAR region and AMS region for multi region connectivity.

## Architecture:
The architecture consists of the following steps:

- Create multiple VPCs and their subnets on the two regions.

- Create a VPC peering between DMZ/Private VPC and CPE VPC, if the peer VPC is your own, no need to accept the peering.
For cross-tenant VPCs you must accept the peering.

- Create an RSA keypair for logging and securing access to the ECS instances.

- Create security groups for the resources in the VPC to control inbound and outbound traffic to the resources.

- Create two ECS firewall instances, with three NICs, one attached to inbound subnet, and the other to the outbound subnet. the SYNC subnet will carry syncronization traffic between the two firewalls for Active/Standby support. [KeepAlived utility could be used to manages the failover using VRRP protocol]
> Please make sure to disable manually "source destination check" on both NICs of the firewall.
<br/>

- Create VIP for high availability, attached on both ECS Firewall instances on inbound and outbound.

- Create an EIP public ip address and attach it to the VIP outbound address.

- Enable AntiDDOS on EIP public ip address.

- Create default routes on VPCs route tables to redirect inbound/outbound traffic through Firewall instances.

- Create AS config, AS Group, for high availability and elasticity.

- Create "Private VPC" resources including RDS Database and ECS instances.

- Create VPN Gateway on PARIS region.

- Establish VPN tunnel from ECS Firewall instance to VPN Gateway on PARIS region.

- Configure the firewall ECS instances to allow only authorized traffic to enter and leave the VPC based on predetermined security rules.
<br/>


## Vars / Arguments Reference
The following vars / arguments  parameters are expected : terraform variables are declared in vars.tf, and defined in terraform.tfvars

Name | Type      | Description
-----|-----------|------------
ak | string | The access key of the FlexibleEngine cloud
sk | string | The secret key of the FlexibleEngine cloud
domain_name | string | The Name of the Domain to scope to
tenant_name | string | The Name of the Project to login with
region | string | Region of the FlexibleEngine cloud
tag | string | Tag of FlexibleEngine resources
db_pass | string | The password of RDS DB database
cidr_vpc | string | The VPC CIDR of the CPE VPC
cidr_subnet_in | String | the inbound subnet of CPE VPC
cidr_subnet_out | String | the outbound subnet of CPE VPC that will be exposed to Internet through EIP.
cidr_subnet_sync | String | the SYNC subnet that carry syncronization traffic between two firewall instances
gateway_in | string | The gateway ip address of inbound subnet
gateway_out | string | The gateway ip address of outbound subnet
gateway_sync | string | The gateway ip address of sync subnet
cidr_dmz_vpc | string | The VPC CIDR of the DMZ VPC
cidr_subnet_dmz | String | the DMZ subnet that will hold external-facing services to the Internet.
dmz_gateway | string | The gateway ip address of DMZ subnet
cidr_private_vpc | string | The private VPC CIDR
cidr_subnet_private | String | The private subnet CIDR
private_gateway | string | The gateway ip address of private subnet
cidr_remote_vpc | string | The remote VPC CIDR
cidr_subnet_remote | String | The remote subnet CIDR
remote_gateway | string | The gateway ip address of remote subnet


## Output / Attributes Reference
The following attributes / output parameters are produced : terraform output variables are defined in outputs.tf

Name | Description
-----|------------
ip_firewall1_in | Firewall 1 ip address of network interface card attached to inbound subnet
ip_firewall1_out | Firewall 1 ip address of network interface card attached to outbound subnet
ip_firewall2_in | Firewall 2 ip address of network interface card attached to inbound subnet
ip_firewall2_out | Firewall 2 ip address of network interface card attached to outboud subnet
vip_in | virtual ip address exposed to inbound subnet
vip_out | virtual ip address exposed to outbound subnet
<br/>

## Diagram:
![Alt text](https://github.com/FlexibleEngineCloud/FE-landingzone/blob/main/docs/designs/vpnaas-dmz-private-multiregion.png)
