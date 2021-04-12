resource "aws_db_instance" "first" {
  engine                  = "mysql"
  engine_version          = "8.0.20"
  instance_class          = "db.t2.micro"
  username                = "ssp"
  parameter_group_name    = "default.mysql8.0"
  allocated_storage       = 20
  max_allocated_storage   = 25
  backup_retention_period = 7
  backup_window           = "19:45-20:15"
  copy_tags_to_snapshot   = true
  ca_cert_identifier      = "rds-ca-2019"
  db_subnet_group_name    = "default-vpc-04e1cb7c7e7f0f5f5"
  publicly_accessible     = true
  skip_final_snapshot     = true
  deletion_protection     = true
  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery",
  ]
}
