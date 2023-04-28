output jupyter_passsword {
  value     = random_password.jupyter_password.result
  sensitive = true
}

output instance_dns {
    value = aws_eip.linux-eip.public_dns
}

output instance_ip {
    value = aws_eip.linux-eip.public_ip
}