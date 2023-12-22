resource "aws_vpc" "custom_vpc" {
  assign_generated_ipv6_cidr_block = true
  cidr_block                       = var.vpc_cidr_block
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = {
    Name = "${var.vpc_tag_name}-${var.environment}"
  }
}

### VPC Network Setup
# Create the private subnet
resource "aws_subnet" "private_subnet" {
  count                           = var.number_of_private_subnets
  vpc_id                          = aws_vpc.custom_vpc.id
  cidr_block                      = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone               = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.environment}-${var.project_name}-subnet-private-${var.region_identifiers[count.index]}"
  }
}

# Create the public subnets
resource "aws_subnet" "public_subnet" {
  count             = var.number_of_private_subnets
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = element(var.public_subnet_cidr_blocks, count.index)
#  assign_ipv6_address_on_creation = true
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.environment}-${var.project_name}-subnet-public-${var.region_identifiers[count.index]}"
  }
}

resource "aws_internet_gateway" "internet_access" {
  vpc_id = aws_vpc.custom_vpc.id
  tags   = {
    Name        = "${var.environment}-${var.project_name}-igw"
    Environment = var.environment
  }
}

resource "aws_eip" "nat_gateway_ip" {
  count      = var.number_of_private_subnets
  vpc        = true
  depends_on = [aws_internet_gateway.internet_access]
  tags       = {
    Name = "${var.environment}-${var.project_name}-eip-nat-gateway-${var.region_identifiers[count.index]}"
  }
}


resource "aws_nat_gateway" "nat_gateway" {
  count         = var.number_of_private_subnets
  allocation_id = element(aws_eip.nat_gateway_ip, count.index).id
  subnet_id     = element(aws_subnet.public_subnet, count.index).id

  tags = {
    Name = "${var.environment}-${var.project_name}-nat-gateway-${var.region_identifiers[count.index]}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.nat_gateway_ip]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_access.id
  }
  tags = {
    Name = "${var.environment}-${var.project_name}-rtb-public"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.number_of_private_subnets
  subnet_id      = element(aws_subnet.public_subnet, count.index).id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = var.number_of_private_subnets
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "${var.environment}-${var.project_name}-rtb-private-${var.region_identifiers[count.index]}"
  }
}

resource "aws_route" "public_access" {
  count                  = var.number_of_private_subnets
  route_table_id         = element(aws_route_table.private, count.index).id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [
    aws_route_table.private
  ]
  nat_gateway_id = element(aws_nat_gateway.nat_gateway, count.index).id
}


resource "aws_route_table_association" "private" {
  count          = var.number_of_private_subnets
  subnet_id      = element(aws_subnet.private_subnet, count.index).id
  route_table_id = element(aws_route_table.private, count.index).id
}
