resource "aws_vpc" "main" {
  # Step 1: Create a VPC
  cidr_block           = var.vpc_cidr
  instance_tenancy     = local.instance_tenancy
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.vpc_tags
}

resource "aws_internet_gateway" "gw" {
  # Step 2: Attach internet Gateway to VPC
  vpc_id = aws_vpc.main.id

  tags = var.igw_tags
}

resource "aws_subnet" "public" {
  # Step 3: Create a public subnet
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]

  tags = merge(
    var.public_subnet_tags, {
      Name = "${var.project_name}-public-${local.azs_labels[count.index]}"
    }
  )
}

resource "aws_subnet" "private" {
  # Step 3: Create a private subnet
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]

  tags = merge(
    var.private_subnet_tags, {
      Name = "${var.project_name}-private-${local.azs_labels[count.index]}"
    }
  )
}

resource "aws_route_table" "public" {
  # Step 4: Create a Route table for public subnets
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(
    var.public_route_table_tags, {
      Name = "${var.project_name}-public"
    }
  )
}

resource "aws_route_table_association" "public" {
  # Step 5: Associating Public Route Table with multiple Public Subnets
  count          = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  # Step 6: Create a Route table for private subnets
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    var.private_route_table_tags, {
      Name = "${var.project_name}-private"
    }
  )

  depends_on = [aws_nat_gateway.nat]
}

resource "aws_route_table_association" "private" {
  # Step 7: Associating private Route Table with multiple private Subnets
  count          = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "nat" {
  # Step 8: Elastic IP
  domain = "vpc"
  tags = merge(
    var.eip_tags, {
      Name = "${var.project_name}"
    }
  )
}

resource "aws_nat_gateway" "nat" {
  # Step 9: Add NAT Gateway
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.nat_gateway_tags, {
      Name = "${var.project_name}"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

## Database

resource "aws_subnet" "database" {
  # Step 1: Create a database subnet
  count             = length(var.database_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]

  tags = merge(
    var.database_subnet_tags, {
      Name = "${var.project_name}-database-${local.azs_labels[count.index]}"
    }
  )
}


resource "aws_route_table" "database" {
  # Step 2: Create a Route table for database subnets
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    var.database_route_table_tags, {
      Name = "${var.project_name}-database"
    }
  )

  depends_on = [aws_nat_gateway.nat]
}

resource "aws_route_table_association" "database" {
  # Step 3: Associating database Route Table with multiple database Subnets
  count          = length(var.database_subnet_cidr)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}
