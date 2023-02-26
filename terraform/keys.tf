resource "aws_key_pair" "tf_key" {
  key_name   = "tf_key"
  public_key = tls_private_key.rsa_keys.public_key_openssh
}


resource "tls_private_key" "rsa_keys" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "priv_key" {
  content  = tls_private_key.rsa_keys.private_key_pem
  filename = "./key/priv_key.pem"

}