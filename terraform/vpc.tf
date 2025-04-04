# Criação de uma VPC com DNS ativado
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
}

# Subnet pública na zona de disponibilidade us-east-1a
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true # Garante IP público automático para instâncias
}

# Subnet pública na zona de disponibilidade us-east-1b
resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

# Security Group que permite tráfego de entrada nas portas 443 e 8080
resource "aws_security_group" "sg" {
  name = "sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Allows HTTP traffic from any source"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allows HTTP traffic from any source"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allows all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Gateway de Internet para acesso externo à VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

# Tabela de rotas associada à VPC para rotear tráfego externo
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  # Rota padrão IPv4 para fora da VPC via Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }
}

# Associação da subnet1 com a tabela de rotas
resource "aws_route_table_association" "route1" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.subnet1.id
}

# Associação da subnet2 com a tabela de rotas
resource "aws_route_table_association" "route2" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.subnet2.id
}

