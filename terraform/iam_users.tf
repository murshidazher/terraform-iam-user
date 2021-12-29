# users.tf

# creating AWS IAM user
resource "aws_iam_user" "iam_user" {
  name = var.iam_user

  tags = {
    Region      = "${var.aws_region}"
    Provisioner = "iam-user"
    Name        = "${var.iam_user}"
  }
}

# add the user to groups
resource "aws_iam_user_group_membership" "iam_user_group_membership" {
  user   = aws_iam_user.iam_user.name
  groups = var.iam_groups
}

# import the pgp key for secret encryption
data "local_file" "pgp_key" {
  filename = var.pgp_key_path
}

# grant programmatic access
resource "aws_iam_access_key" "iam_user_programmatic_access" {
  user = aws_iam_user.iam_user.name
  pgp_key = data.local_file.pgp_key.content_base64
}

# create use console access
resource "aws_iam_user_login_profile" "login_profile" {
  user                    = aws_iam_user.iam_user.name
  password_reset_required = false # TODO: true in prod environement
  pgp_key = data.local_file.pgp_key.content_base64
}
