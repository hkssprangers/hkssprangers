module "dynamodb_table_terraform" {
  source   = "terraform-aws-modules/dynamodb-table/aws"
  version  = "4.0.0"

  name     = "terraform"
  hash_key = "LockID"

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]
}