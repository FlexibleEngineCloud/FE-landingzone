# MultiCloud DMZ, Production/Dev Environment via Orange BusinessVPN :
This is a guide to implementing a multicloud architecture with DMZ,Prod/Dev environment. by controlling traffic flow between your On-Premise/Internet and your FE infrastructure.
<br/>
This architecture uses an open source firewall (pfsense) deployed on an ECS instance using an pre-built IMS image, allowing only authorized traffic to enter and leave the DMZ/Prod/Dev network on FE infastructure. 
<br/>
This documentation will provide an overview of this architecture and its components.


## Components:
The MultiCloud DMZ, Production/Dev Environment architecture consists of the following components:

- Virtual Private Cloud (VPC): A VPC is a logically isolated virtual network within the FE (Flexible Engine) Cloud. It provides a secure and scalable environment for resources to run within.

- Subnets: Subnets are logical partitions within a VPC that allow resources to be deployed in different network segments.

- Security Groups: Security groups act as virtual firewalls that control inbound and outbound traffic to instances associated with them.

- EIP: a public IPv4 address assigned to the virtualIP to allow for internet connectivity.

- VPC Peering: a VPC peering connection between VPCs that enables to route traffic.

- VirtualIP: Virtual IP address for high availability attached on multiple firewalls.

- AutoScaling Group: Automatically adjusts ECS server capacity based on traffic load.

- LoadBalancer: Distributes traffic across multiple servers, in this architecture AutoScaling Group.

- NetworkACL: Network Access Control List for controling traffic on subnets.

- SFS-Turbo: Shared File System Turbo for high-performance file sharing.

- MRS Cluster: Managed Resource Service for data processing.

- RDS: Relational Database Service for data storage.


## Architecture:
The architecture consists of the following steps:

- Create multiple VPCs and their subnets.

- Create a VPC peering between DMZ/Prod/Dev VPC and CPE VPC, if the peer VPC is your own, no need to accept the peering.
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

- Create AS config, AS Group, LoadBalancer, for high availability and elasticity.

- Create "Production application" resources including BMS, ECS instances.

- Create "Production data" resources including SFS file system sharing, MRS Cluster and RDS relational database.

- DirectConnect connection to connect On-Perm data center via "Orange BusinessVPN" to FlexibleEngine VPC.

- IPSec VPN tunnel from ECS Firewall instance to Third-party cloud platform. 

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
db_pass | string | The password of RDS DB database
mrs_pass | string | The password of MRS cluster manager
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
cidr_prod_vpc | string | The VPC CIDR of the Production VPC
cidr_subnet_app | String | the app subnet that carry application resources
cidr_subnet_data | String | the data subnet that carry data resources
app_gateway | string | The gateway ip address of app subnet
data_gateway | string | The gateway ip address of data subnet
cidr_dev_vpc | string | The VPC CIDR of the Dev VPC
cidr_subnet_dev | String | the dev subnet
dev_gateway | string | The gateway ip address of dev subnet


## Output / Attributes Reference
The following attributes / output parameters are produced : terraform output variables res defined in outputs.tf

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
![Alt text](https://github.com/FlexibleEngineCloud/FE-landingzone/blob/main/docs/designs/bvpn-dmz-prod-dev-multicloud.png)
