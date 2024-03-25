### Creation du vpc roland
resource "aws_vpc" "roland_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "roland-vpc"
  }
}

### Creation des 2 sous-réseaux public pour les serveurs roland
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.roland_vpc.id
  cidr_block              = var.cidr_public_subnet_a
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_a
  tags = {
    Name        = "public-a",
    Environment = "var.environment"
  }
  depends_on = [aws_vpc.roland_vpc]
}
resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.roland_vpc.id
  cidr_block              = var.cidr_public_subnet_b
  map_public_ip_on_launch = "true"
  availability_zone       = var.az_b
  tags = {
    Name        = "public-b",
    Environment = "var.environment"
  }
  depends_on = [aws_vpc.roland_vpc]
}
##################################################### 

### Creation des 2 sous-réseaux privées pour les serveurs roland
resource "aws_subnet" "app_subnet_a" {
  vpc_id            = aws_vpc.roland_vpc.id
  cidr_block        = var.cidr_app_subnet_a
  availability_zone = var.az_b
  tags = {
    Name        = "app-a",
    Environment = "var.environment"
  }
  depends_on = [aws_vpc.roland_vpc]
}
resource "aws_subnet" "app_subnet_b" {
  vpc_id            = aws_vpc.roland_vpc.id
  cidr_block        = var.cidr_app_subnet_b
  availability_zone = var.az_b
  tags = {
    Name        = "app-b",
    Environment = "var.environment"
  }
  depends_on = [aws_vpc.roland_vpc]
}

##################################################### 
# Créer une passerelle Internet pour notre VPC
resource "aws_internet_gateway" "roland_igateway" {
  vpc_id = aws_vpc.roland_vpc.id

  tags = {
    Name = "roland-igateway"
  }

  depends_on = [aws_vpc.roland_vpc]
}
##################################################### 

# Créez une table de routage afin que nous puissions attribuer un sous-réseau public-a et public-b à cette table de routage
resource "aws_route_table" "rtb_public" {

  vpc_id = aws_vpc.roland_vpc.id
  tags = {
    Name = "roland-public-routetable"
  }

  depends_on = [aws_vpc.roland_vpc]
}

##################################################### 

# Créez une route dans la table de routage, pour accéder au public via une passerelle Internet
resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.roland_igateway.id

  depends_on = [aws_internet_gateway.roland_igateway]
}

# Ajouter un sous-réseau public-a à la table de routage
resource "aws_route_table_association" "rta_subnet_association_puba" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.rtb_public.id

  depends_on = [aws_route_table.rtb_public]
}

# Ajouter un sous-réseau public-b à la table de routage
resource "aws_route_table_association" "rta_subnet_association_pubb" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.rtb_public.id

  depends_on = [aws_route_table.rtb_public]
}
##################################################### 


## Créer une passerelle nat pour le sous-réseau public a et une ip élastique
resource "aws_eip" "eip_public_a" {
  #vpc = true
  domain = "vpc"
}
resource "aws_nat_gateway" "gw_public_a" {
  allocation_id = aws_eip.eip_public_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "roland-nat-public-a"
  }
}

##################################################### 

## Créer une table de routage pour app un sous-réseau
resource "aws_route_table" "rtb_appa" {

  vpc_id = aws_vpc.roland_vpc.id
  tags = {
    Name = "roland-appa-routetable"
  }

}
##################################################### 

#créer une route vers la passerelle nat
resource "aws_route" "route_appa_nat" {
  route_table_id         = aws_route_table.rtb_appa.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw_public_a.id
}


resource "aws_route_table_association" "rta_subnet_association_appa" {
  subnet_id      = aws_subnet.app_subnet_a.id
  route_table_id = aws_route_table.rtb_appa.id
}

##################################################### 
## Créer une passerelle Nat et des routes pour le sous-réseau b de l'application et l'ip élastique pour la passerelle b
resource "aws_eip" "eip_public_b" {
  #vpc = true
  domain = "vpc"
}
resource "aws_nat_gateway" "gw_public_b" {
  allocation_id = aws_eip.eip_public_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "roland-nat-public-b"
  }
}

resource "aws_route_table" "rtb_appb" {

  vpc_id = aws_vpc.roland_vpc.id
  tags = {
    Name = "roland-appb-routetable"
  }

}

resource "aws_route" "route_appb_nat" {
  route_table_id         = aws_route_table.rtb_appb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw_public_b.id
}


resource "aws_route_table_association" "rta_subnet_association_appb" {
  subnet_id      = aws_subnet.app_subnet_b.id
  route_table_id = aws_route_table.rtb_appb.id
}
##################################################### FIN
