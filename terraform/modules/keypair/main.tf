# KeyPair Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

# Create RSA Key Pair
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Save the private RSA Key in root directory of the folder,
# Please make sure to preserve the key carefully.
resource "flexibleengine_compute_keypair_v2" "keypair" {
  name       = var.keyname
  public_key = tls_private_key.key.public_key_openssh
  provisioner "local-exec" { # Generate "TF-Keypair-firewall.pem" in current directory
    command = <<-EOT
      echo '${tls_private_key.key.private_key_pem}' > ./'${var.keyname}'.pem
      chmod 400 ./'${var.keyname}'.pem
    EOT
  }  
}