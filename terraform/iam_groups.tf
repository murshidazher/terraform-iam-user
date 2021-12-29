# policies.tf
# add user password policies
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = false
  allow_users_to_change_password = true
}

/*
 * This policy grants readonly acccess to S3
 */
data "template_file" "s3_readonly_access_policy_doc" {
  template = file("${path.module}/policies/s3_readonly_access_policy.json")
}

resource "aws_iam_group_policy" "s3_readonly_access_policy" {
  name   = "s3_readonly_access_policy"
  group  = aws_iam_group.iam_group_s3.id
  policy = data.template_file.s3_readonly_access_policy_doc.rendered
}

resource "aws_iam_group" "iam_group_s3" {
  name = "s3_group"
}

/*
 * This policy grants cloudwatch readonly access.
 */
data "template_file" "cloudwatch_readonly_access_policy_doc" {
  template = file("${path.module}/policies/cloudwatch_readonly_access_policy.json")
}

resource "aws_iam_group_policy" "cloudwatch_readonly_access_policy" {
  name   = "cloudwatch_readonly_access_policy"
  group  = aws_iam_group.iam_group_cloudwatch.id
  policy = data.template_file.cloudwatch_readonly_access_policy_doc.rendered
}

resource "aws_iam_group" "iam_group_cloudwatch" {
  name = "cloudwatch_group"
}
