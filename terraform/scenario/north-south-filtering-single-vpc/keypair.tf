# Creation of a Key Pair
resource "tls_private_key" "key" {
  algorithm   = "RSA"
  rsa_bits    = 4096
}
# Save the private RSA Key in root directory of the folder,
# Please make sure to preserve the key carefully.
resource "flexibleengine_compute_keypair_v2" "keypair" {
  name       = "${var.generated_key_name}-${random_string.id.result}"
  public_key = tls_private_key.key.public_key_openssh
  provisioner "local-exec" {    # Generate "TF-Keypair.pem" in current directory
    command = <<-EOT
      echo '${tls_private_key.key.private_key_pem}' > ./'${var.generated_key_name}-${random_string.id.result}'.pem
      chmod 400 ./'${var.generated_key_name}-${random_string.id.result}'.pem
    EOT
  }
}