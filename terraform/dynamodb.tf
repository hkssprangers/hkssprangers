module "dynamodb_table_terraform" {
  source   = "terraform-aws-modules/dynamodb-table/aws"
  version  = "3.1.2"

  name     = "terraform"
  hash_key = "LockID"

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]
}