
# Networking Landing Zone Scenarios

the Networking Landing Zone Scenarios section of the Flexible Engine Landing Zone Accelerator. This directory contains various Terraform scenarios for setting up networking configurations within your Flexible Engine environment. These scenarios are designed to help you deploy and manage secure, scalable, and compliant networking resources.


## Available Scenarios
1. **bvpn-dmz-private-multicloud**: This is a guide to implementing a multicloud architecture with DMZ/Private environment. by controlling traffic flow between your On-Premise/Internet and your FE infrastructure.
This architecture uses an open source firewall (pfsense) deployed on an ECS instance using an pre-built IMS image, allowing only authorized traffic to enter and leave the DMZ/Private network on FE infastructure.

2. **bvpn-dmz-prod-dev-multicloud**: This is a guide to implementing a multicloud architecture with DMZ,Prod/Dev environment. by controlling traffic flow between your On-Premise/Internet and your FE infrastructure.
This architecture uses an open source firewall (pfsense) deployed on an ECS instance using an pre-built IMS image, allowing only authorized traffic to enter and leave the DMZ/Prod/Dev network on FE infastructure.

3. **north-south-filtering-multi-vpc**: This is a guide to implementing a multi VPC North-South Filtering for your Flexible Engine (FE) infrastructure. by controlling traffic flow between your On-Premise and your FE infrastructure.
This architecture uses an open source firewall (pfsense) deployed on an ECS instance using an pre-built IMS image, allowing only authorized traffic to enter and leave the LAN/Private network on FE infastructure.

4. **north-south-filtering-single-vpc**: Similar to the previous scenario, this one applies north-south traffic filtering but within a single Virtual Private Cloud (VPC).

5. **vpnaas-dmz-private**: This is a guide to implementing a VPNaaS architecture with DMZ/Private in multi region environment (eu-west-0/eu-west-1). by controlling traffic flow between public network and your FE infrastructure in multi region.
This architecture uses an open source firewall (pfsense) deployed on an ECS instance using an pre-built IMS image, allowing only authorized traffic to enter and leave the DMZ/Private network on FE infastructure.
