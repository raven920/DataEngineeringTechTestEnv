# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
  #prevent_destroy = true
}
# Create the Key Pair
resource "aws_key_pair" "key_pair" {
    
  key_name   = "linux-key-pair"  
  public_key = tls_private_key.key_pair.public_key_openssh
  #prevent_destroy = true
}
# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
  #prevent_destroy = true
}