module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.0.0"

  identifier = "wp-db"

  engine                    = "mariadb"
  engine_version            = "10.6.7"
  create_db_parameter_group = "false"
  create_db_option_group    = "false"
  skip_final_snapshot       = "true"
  create_random_password    = "false"
  instance_class            = "db.t3.micro"
  allocated_storage         = 10
  max_allocated_storage     = 15

  username = "admin"
  db_name  = "wordpressdb"
  password = var.db_pass
  port     = 3306

  multi_az               = "true"
  create_db_subnet_group = "true"
  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [aws_security_group.sg_rds.id]
}