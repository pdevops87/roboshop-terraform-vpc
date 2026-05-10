#  create VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
 tags = {
    Name = "${var.env}-vpc"
  }
}

# create subnets
# public and private

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnets
  tags = {
    Name = "${var.env}-public-sub"
  }
}

resource "aws_subnet" "private" {
  count = var.private_subnets
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnets
  tags = {
    Name = "${var.env}-private-sub-${count.index}"
  }
}

# create a route table
# public and private

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-public-rtable"
  }
}

resource "aws_route_table" "private" {
  count = var.private_subnets
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-private-rtable-${count.index}"
  }
}

# associate route table to their respective subnets

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = var.private_subnets
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# create peer connection between two vpc's
resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id   = var.default_vpc_cidr_block
  vpc_id        = var.vpc_cidr
  auto_accept = true
}

# create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-igw"
  }
}
# add igw in public route table(routes)
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

# create eip
resource "aws_eip" "eip"{
domain = "vpc"
  tags = {
    Name = "${var.env}-eip"
  }
}

#  create NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.private.id
  tags = {
    Name = "${var.env}-nat"
  }
}

# add NAT to private subnets in route table(routes)
resource "aws_route" "private" {
  count = var.private_subnets
  route_table_id            = aws_route_table.private[count.index].id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
#   construct peer (add in private routes)
  vpc_peering_connection_id = aws_vpc_peering_connection.peer[count.index].id
}






