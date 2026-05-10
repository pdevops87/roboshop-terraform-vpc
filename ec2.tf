resource "aws_instance" "instance" {
  for_each = var.components
  ami           = var.ami
  instance_type = each.value["instance_type"]
  subnet_id = aws_subnet.private[0].id
  security_groups = [aws_security_group.sg[each.key].id]
#   to stop recreating an instance whenever there are any update/changes
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = each.key
  }
}

resource "aws_route53_record" "record" {
  for_each         =    var.components
  zone_id          =    var.zone_id
  name             =    "${each.key}-${var.env}"
  type             =    "A"
  ttl              =     5
  records          =   [aws_instance.instance[each.key].private_ip]
}

resource "null_resource" "provisioner" {
  for_each      = var.components
  depends_on = [
    aws_instance.instance,
    aws_route53_record.record
  ]
  triggers = {
    timestamp = timestamp()
    instance_id = aws_instance.instance[each.key].id
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "DevOps321"
      host     = aws_instance.instance[each.key].private_ip
    }
    inline = [
      "sudo dnf install python3.11-pip -y",
      "sudo pip3.11 install ansible",
      "ansible-pull -i localhost, -U https://github.com/pdevops87/roboshop-ansible-v4 roboshop.yaml -e component=${each.key} -e env=${var.env}"
    ]
  }
}