/* Console login password
 * use the output to decrypt the password using below command
 * terraform output -raw iam_user_password | base64 --decode | gpg --decrypt
 */
output "iam_user_password" {
  description = "aws console login password"
  value       = aws_iam_user_login_profile.login_profile.encrypted_password
}

output "iam_user_access_key_id" {
  description = "programmtic access id"
  value = aws_iam_access_key.iam_user_programmatic_access.id
}

/*
* Programmtic access key
* use the output to decrypt the password using below command
* terraform output -raw iam_user_access_key_secret | base64 --decode | gpg --decrypt
*/
output "iam_user_access_key_secret" {
  description = "programmtic access key"
  value       = aws_iam_access_key.iam_user_programmatic_access.encrypted_secret
}


