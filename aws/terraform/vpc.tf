# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(local.azs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public-${count.index + 1}"
    Type = "Public"
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(local.azs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 11}.0/24"
  availability_zone = local.azs[count.index]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-private-${count.index + 1}"
    Type = "Private"
  })
}

# Database Subnets
resource "aws_subnet" "database" {
  count = length(local.azs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 21}.0/24"
  availability_zone = local.azs[count.index]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-database-${count.index + 1}"
    Type = "Database"
  })
}

# NAT Gateway (Commented out for cost optimization - saves $32/month)
# resource "aws_eip" "nat" {
#   count = 1  # Only one NAT Gateway for cost savings
# 
#   domain = "vpc"
#   depends_on = [aws_internet_gateway.main]
# 
#   tags = merge(local.common_tags, {
#     Name = "${local.name_prefix}-nat-eip"
#   })
# }
# 
# resource "aws_nat_gateway" "main" {
#   count = 1  # Only one NAT Gateway
# 
#   allocation_id = aws_eip.nat[0].id
#   subnet_id     = aws_subnet.public[0].id  # Use first public subnet
# 
#   tags = merge(local.common_tags, {
#     Name = "${local.name_prefix}-nat"
#   })
# 
#   depends_on = [aws_internet_gateway.main]
# }

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public-rt"
  })
}

# Private route table (commented out - using public subnets for ECS to save NAT Gateway costs)
# resource "aws_route_table" "private" {
#   count = length(local.azs)
# 
#   vpc_id = aws_vpc.main.id
# 
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.main[0].id  # All private subnets use single NAT Gateway
#   }
# 
#   tags = merge(local.common_tags, {
#     Name = "${local.name_prefix}-private-rt-${count.index + 1}"
#   })
# }

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-database-rt"
  })
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private route table associations (commented out - using public subnets for ECS)
# resource "aws_route_table_association" "private" {
#   count = length(aws_subnet.private)
# 
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private[count.index].id
# }

resource "aws_route_table_association" "database" {
  count = length(aws_subnet.database)

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

# Database Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-subnet-group"
  })
}