resource "aws_db_subnet_group" "db_subnet" {
  name       = "aegissync-db-subnet"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_db_instance" "primary" {
  identifier        = "aegissync-db"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = "admin"
  password = "StrongPassword123!"

  db_subnet_group_name = aws_db_subnet_group.db_subnet.name

  multi_az = true  # 🔥 Multi-AZ standby

  publicly_accessible = false
}

# READ REPLICA
resource "aws_db_instance" "replica" {
  identifier          = "aegissync-read-replica"
  replicate_source_db = aws_db_instance.primary.id

  instance_class = "db.t3.micro"
  publicly_accessible = false
}