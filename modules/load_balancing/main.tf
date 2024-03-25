

## Création d'un load balancer dans deux sous-réseaux publics
resource "aws_lb" "lb_roland" {
  name               = "roland-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids                #["${aws_subnet.public_subnet_a.id}", "${aws_subnet.public_subnet_b.id}"]
  security_groups    = [var.security_groups_application_lb] #["${aws_security_group.sg_application_lb.id}"]

  enable_deletion_protection = false
}
##Création d'un écouteur d'équilibrage de charge qui accepte les requêtes sur le port 80 et les redirigent à notre groupe cible

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb_roland.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.roland_vms.arn

  }
}
#Création d'un groupe cible:
resource "aws_lb_target_group" "roland_vms" {
  name     = "tf-roland-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}



resource "aws_lb_target_group" "roland_vms_B" {
  name     = "tf-roland-lb-tg-B"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

