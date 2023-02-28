# Best Practices for Terraform Secrets Management
While using Terraform, it is important to properly manage and protect sensitive information, such as access/secret keys, tokens, passwords, and other secrets. In this document, we outline best practices for securely managing Terraform secrets.

## Avoid Hardcoding Secrets in Terraform Code
Hardcoding FlexibleEngine secrets in your Terraform code is not a secure practice. Anyone with access to your code repository can see your secrets. and so could accesss to your FlexibleEngine infrastructure.
```
variable "access_key" {
  type = string
}
```
You must replace the hard-coded credentials with variables configured with the sensitive flag. 
- Next, you can set values for these variables using environment variables and with a .tfvars file. 
```
variable "access_key" {
  type = string
  sensitive = true
}
```
for example, secret.tfvars
```
ak = XXXXXXXXXX
sk = XXXXXXXXXX
```
Apply these changes using the -var-file parameter. and respond to the confirmation prompt with yes.
```
$ terraform apply -var-file="secret.tfvars"
...
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
...
```

- Or, using environment variables, 
```
# Set secrets via environment variables
export TF_VAR_ak=XXXXXXXXXX
export TF_VAR_sk=XXXXXXXXXX

# And apply the changes
terraform apply
```


## Use a Secret Management System
It is essential to use a dedicated secret management system to securely store and manage secrets used in Terraform. Secrets should not be hard-coded in Terraform code, version control systems or plain text files. Popular secret management systems include:

- HashiCorp Vault
- AWS Secrets Manager
- Google Cloud Secret Manager
- Azure Key Vault

Access to secrets should be limited to only those who require it to perform their duties. Access should be granted based on the principle of least privilege. This means that users should only be granted the minimum level of access necessary to perform their job duties.
-- to be completed --

## Use Encryption
When transferring secrets, they should be encrypted both in transit and at rest. TLS should be used when transferring secrets over the network, and secrets should be encrypted when stored in the secret management system. Terraform also has the capability to encrypt state files using a passphrase.
-- to be completed --

## Conclusion
Proper management of Terraform secrets is critical to maintaining the security of your infrastructure. By following the best practices you can reduce the risk of secrets being compromised.