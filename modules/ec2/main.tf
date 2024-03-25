# recupération dynamique de l'image avec les data sources
data "aws_ami" "roland-ami" { # déclaration de la source de données de type aws_ami (ami aws)
  most_recent = true          # demande à avoir l'image la plus recente disponible
  owners      = ["amazon"]    # Le proriétaire de l'image

  filter {          # on ajoute un filtre
    name   = "name" # on veut filtrer l'image lorsque le nom commence par amzn2-ami-hvm-*
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_key_pair" "myec2key" {
  key_name   = "roland_keypair_${var.key_id}"
  public_key = file("~/.ssh/id_rsa.pub")
}

## Création du serveur roland pour le sous-réseau d'application A
resource "aws_instance" "roland_a" {
  ami                    = data.aws_ami.roland-ami.id
  instance_type          = "t2.micro"
  subnet_id              = var.app_subnet_ids[0] #aws_subnet.app_subnet_a.id
  vpc_security_group_ids = [var.sg_roland_id]
  key_name               = aws_key_pair.myec2key.key_name
  user_data              = file("install_wordpress.sh")
  tags = {
    Name = "roland-a"
  }
}

## Fin

## Création de serveur roland pour le sous-réseau d'application B

resource "aws_instance" "roland_b" {
  ami                    = data.aws_ami.roland-ami.id
  instance_type          = "t2.micro"
  subnet_id              = var.app_subnet_ids[1] #aws_subnet.app_subnet_b.id
  vpc_security_group_ids = [var.sg_roland_id]
  key_name               = aws_key_pair.myec2key.key_name
  user_data              = file("install_wordpress.sh")
  tags = {
    Name = "roland-b"
  }

}
## Fin


# Configuration de la base de données principale
resource "aws_db_instance" "database_instance" {
  allocated_storage = 10
  engine            = "mysql"
  identifier        = "primary-db"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  username          = "db_user"
  password          = "db_password"
  #name                 = "db_name"
  parameter_group_name = "default.mysql5.7"
  multi_az             = true
  #availability_zone    = "eu-west-3a"

  tags = {
    Name = "wordpressdb-main"
  }
}

# Configuration de la base de données secondaire
resource "aws_db_instance" "database_instance_secondary" {
  allocated_storage = 10
  engine            = "mysql"
  identifier        = "secondary-db"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  username          = "db_user"
  password          = "db_password"
  #name                 = "db_name_secondary" 
  parameter_group_name = "default.mysql5.7"
  multi_az             = true
  #availability_zone    = "eu-west-3b"

  tags = {
    Name = "wordpressdb-secondary"
  }
}




## Joindre l' instance A à la zone de disponibilté A au groupe cible
resource "aws_lb_target_group_attachment" "roland_tg_attachment" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.roland_a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "roland_tg_attachment_B" {
  target_group_arn = var.target_group_arn_B
  target_id        = aws_instance.roland_b.id
  port             = 80
}
