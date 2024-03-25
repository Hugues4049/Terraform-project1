## Création d'un équilibreur de charge d'application pour accéder à l'application
resource "aws_security_group" "sg_application_lb" {

  name   = "sg_application_lb"
  vpc_id = var.vpc_id


  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    # Veuillez limiter votre entrée aux seules adresses IP et ports nécessaires.
    # L'ouverture à 0.0.0.0/0 peut entraîner des failles de sécurité.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "roland-alb"
  }

}

resource "aws_security_group" "sg_22" {

  name   = "sg_22"
  vpc_id = var.vpc_id #"aws_vpc.roland_vpc.id"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-22"
  }
}

# Créer un NACL pour accéder à l'hôte bastion via le port 22
resource "aws_network_acl" "rolan_public_a" {
  vpc_id = var.vpc_id #"aws_vpc.roland_vpc.id"

  subnet_ids = [var.public_subnet_ids[0]]

  tags = {
    Name = "acl-roland-public-a"
  }
}

######## Roland
# Créer un NACL pour accéder à l'hôte bastion via le port 22
resource "aws_network_acl" "rolan_public_b" {
  vpc_id     = var.vpc_id #"$ws_vpc.roland_vpc.id"
  subnet_ids = [var.public_subnet_ids[1]]

  tags = {
    Name = "acl-roland-public-b"
  }
}
########


resource "aws_network_acl_rule" "nat_inbound" {
  #network_acl_id = aws_network_acl.roland_public_a.id
  network_acl_id = var.aws_network_acl_a_id
  rule_number    = 200
  egress         = false
  protocol       = "-1" #Tous les protocles (TCP/UDP...)
  rule_action    = "allow"
  # L'ouverture à 0.0.0.0/0 peut entraîner des failles de sécurité. vous devez restreindre uniquement l'acces à votre ip publique
  cidr_block = "0.0.0.0/0"
  from_port  = 0
  to_port    = 0
}

resource "aws_network_acl_rule" "nat_inboundb" {
  #network_acl_id = aws_network_acl.roland_public_b.id
  network_acl_id = var.aws_network_acl_b_id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  # L'ouverture à 0.0.0.0/0 peut entraîner des failles de sécurité. vous devez restreindre uniquement l'acces à votre ip publique
  cidr_block = "0.0.0.0/0"
  from_port  = 0
  to_port    = 0
}

## Création de serveurs roland pour le sous-réseau d'application A
resource "aws_security_group" "sg_roland" {

  name   = "sg_roland"
  vpc_id = var.vpc_id #"aws_vpc.roland_vpc.id"
  tags = {
    Name = "sg-roland"
  }

}

resource "aws_security_group_rule" "allow_all" {
  type              = "ingress"
  cidr_blocks       = ["10.1.0.0/24"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_roland.id
}

resource "aws_security_group_rule" "outbound_allow_all" {
  type = "egress"

  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_roland.id
}



