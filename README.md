# FlexibleEngine landingzone Accelerator

Landing Zones refers to the pre-configured and secure cloud environments that organizations use to host their applications and workloads. A landing zone is essentially the foundation of a cloud architecture that provides a framework for deploying and managing resources in a secure, scalable, and compliant manner.

This repository contains the Terraform code and related resources necessary to deploy a Landing Zone in FlexibleEngine.


### Benefits of Landing Zones
- Security: A landing zone provides a secure environment for hosting your workloads. By following best practices for security, such as network segmentation, access controls, and encryption, you can minimize the risk of unauthorized access, data breaches, and other security threats.

- Compliance: By implementing compliance controls such as identity and access management, auditing, and monitoring, you can ensure that your landing zone meets regulatory requirements, industry standards, and company policies.

- Scalability: Landing zones are designed to be scalable, allowing you to easily add or remove resources as needed. This ensures that your cloud environment can adapt to changing business needs and growth.

- Efficiency: By standardizing your landing zone architecture, you can streamline the deployment and management of your workloads. This can reduce the time and effort required to deploy new applications, as well as simplify ongoing maintenance and updates.


### Components of a Landing Zone
A landing zone typically consists of several components, including:

- Identity and Access Management (IAM): IAM controls who has access to your landing zone and what they can do. This includes authentication, authorization, and permissions management for users, groups, and roles.
More on [IAM and multi tenancy best practices on Flexible Engine](https://cloud.orange-business.com/en/best-practices-and-how-to/iam-multi-tenancy).

- Networking: Networking includes the configuration of Virtual Private Clouds (VPCs), subnets, routing, and security groups. This ensures that your resources are properly segmented and protected within your landing zone.

- Security: Security includes the implementation of security controls such as firewalls, intrusion detection, and data encryption. This helps to protect your data and workloads from unauthorized access and other security threats.

- Monitoring and Logging: Monitoring and logging enable you to track and analyze the performance and behavior of your landing zone resources. This can help you identify issues and optimize resource usage.

- Operations: Operations include automation, configuration management, and deployment tools that help to simplify the deployment and management of your landing zone resources.


### Best Practices for Landing Zones
When designing and implementing a landing zone, there are several best practices that you should follow to ensure optimal performance, security, and compliance. These include:

- Automation: Use automation tools to streamline the deployment and management of your landing zone resources. This can help to reduce the risk of human error and ensure consistency across your cloud environment.

- Standardization: Standardize your landing zone architecture to simplify deployment and management. This includes using consistent naming conventions, resource tagging, and other best practices.

- Monitoring: Implement monitoring and logging tools to track the performance and behavior of your landing zone resources. This can help you identify and resolve issues before they impact your applications or users.

- Security: Implement security controls such as firewalls, access controls, and data encryption to protect your landing zone resources from unauthorized access and other security threats.

- Compliance: Implement compliance controls such as auditing, monitoring, and identity and access management to ensure that your landing zone meets regulatory requirements and industry standards.

- Scalability: Design your landing zone to be scalable, allowing you to easily add or remove resources as needed. This ensures that your cloud environment can adapt to changing business needs and growth.

In conclusion, Landing Zones are an essential component of a cloud architecture that provides a secure, scalable, and compliant foundation for hosting your workloads.


## Prerequisites
Before you can deploy the Landing Zone in FE, you'll need to have the following:

- A FE account
- Terraform installation

## Repository Contents
This repository contains the following resources:

- docs/ - Documentation for setting up and managing a Landing Zone in FE.
- terraform/ - Terraform modules for creating a Landing Zone in FE.

## Deployment
To get started with this repository, clone it to your local machine:
```
$ git clone https://github.com/FlexibleEngineCloud/FE-landingzone.git
```
After setting authentication method credentials, it could be either, username/password, AK/SK, Token.
You should be able to provision resources on your FlexibleEngine domain.
<br/>
See [SECURITY.md](https://github.com/FlexibleEngineCloud/FE-landingzone/blob/main/SECURITY.md) for best practices managing terraform secrets.

In a terminal, go into the scenario that fits your requirements, and run the terraform init command:
```
$ terraform init
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/tls...
- Finding latest version of hashicorp/random...
- Finding latest version of flexibleenginecloud/flexibleengine...
- Installing flexibleenginecloud/flexibleengine v1.36.0...
- Installed flexibleenginecloud/flexibleengine v1.36.0 
- Installing hashicorp/tls v4.0.4...
- Installed hashicorp/tls v4.0.4 (signed by HashiCorp)
- Installing hashicorp/random v3.4.3...
- Installed hashicorp/random v3.4.3 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!
```
Now, run the terraform plan command:
```
$ terraform plan
Terraform will perform the following actions:
...
```
The plan command lets you see what Terraform will do before actually making any changes.
To actually provision the resources, run the terraform apply command:
```
$ terraform apply
Terraform will perform the following actions:
...
```
Tap "yes", to confirm.
```
Apply complete! Resources: 18 added, 0 changed, 0 destroyed.
```
Congrats, you’ve just deployed a landing zone in your FlexibleEngine account using Terraform! To verify this, head over to the FlexibleEngine console, and you should see your awesome infrastructure ready to go.

### See Also 
- [Automating Flexible Engine Deployments with Terraform and GitHub Actions](https://cloud.orange-business.com/en/how-to/automating-flexible-engine-deployments-with-terraform-and-github-actions).
- [Terraform on Flexible Engine](https://cloud.orange-business.com/en/how-to/terraform-on-flexible-engine).
- [IAM and multi tenancy best practices on Flexible Engine](https://cloud.orange-business.com/en/best-practices-and-how-to/iam-multi-tenancy).

## Contributing
We welcome contributions to this repository! If you would like to contribute, please see our contributing guidelines for more information.

## License
This repository is licensed under the XXXX License. See the LICENSE file for more information.
