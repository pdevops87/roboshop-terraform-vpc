# resource "aws_security_group" "sg" {
#   for_each = var.components
#   vpc_id = aws_vpc.vpc.id
#   name = "${var.env}-${each.key}-sg"
#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port = each.value["port"]
#     to_port = each.value["port"]
#     protocol = "TCP"
#     cidr_blocks = var.private_subnets
#   }
#   tags = {
#     Name = "${var.env}-${each.key}-sg"
#   }
# }

