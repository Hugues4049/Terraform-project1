## Création de la paire de clé du serveur  Bastion

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


resource "aws_instance" "roland_bastion" {
  ami                    = data.aws_ami.roland-ami.id
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.myec2key.key_name

  tags = {
    Name = "roland-bastion"
  }
}
