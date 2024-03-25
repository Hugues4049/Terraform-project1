# recupération dynamique de l'image avec les data sources
data "aws_ami" "roland-ami" { # déclaration de la source de données de type aws_ami (ami aws)
  most_recent = true          # demande à avoir l'image la plus recente disponible
  owners      = ["amazon"]    # Le proriétaire de l'image

  filter {          # on ajoute un filtre
    name   = "name" # on veut filtrer l'image lorsque le nom commence par amzn2-ami-hvm-*
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


# Configuration du groupe Auto Scaling pour les instances du serveur web
resource "aws_launch_configuration" "web_server_config" {
  image_id      = data.aws_ami.roland-ami.id
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_server_asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = var.vpc_zone_identifier


  launch_configuration = aws_launch_configuration.web_server_config.id

  health_check_type         = "EC2"
  health_check_grace_period = 300
}
