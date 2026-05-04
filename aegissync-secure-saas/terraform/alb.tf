resource "aws_lb" "app" {
  name               = "aegissync-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
}