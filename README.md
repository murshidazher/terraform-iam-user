# [terraform-iam-user](https://github.com/murshidazher/terraform-iam-user)

> A demonstration of automating the onboarding of AWS IAM users using terraform. 😉

- It creates two users named `Adam` and `David`.
- Use [aws_iam_access_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key.html) for `Programmatic Access`.
- Test the users and policies attached to the account by heading over to [IAM policy similator](https://policysim.aws.amazon.com/home/index.jsp?#).
- For [loop with terraform](https://jhooq.com/terraform-for-and-for-each-loop/).

## Installation and Usage

> ⚠️ Need to install `terraform: >=1.0.0` and `keybase`.

Create the S3 bucket to store the state file,

```sh
aws s3api create-bucket --bucket terraform-hadoop-openvpn --region us-east-1 --acl private --profile <aws_profile_name>
```

Apply the Changes using terraform,

```sh
git clone git@github.com:murshidazher/terraform-iam-user.git
cd terraform
terraform init
```

### What does it mean by `pgp_key` ? 🤔

> More information on [gpg key](https://menendezjaume.com/post/gpg-encrypt-terraform-secrets/)

By encrypting out terraform secrets, we are not only protecting them when they are output by terraform on screen, but also when they are written to our terraform state files. This is crucial because should our state file go missing, an attacker would not be able to use any of the credentials to compromise our infrastructure.

```sh
gpg -k
gpg --batch --gen-key key-gen-template 
# Success! Now, we are in a position to use our newly created key to sign, encrypt, and decrypt messages. Note: remember the passphrase 
```

Export the `gpg` key to `terraform/keys` directory,

> 💡 If you need to change the path where you keep the keys, just add it to [variables.tf](terraform/variables.tf) `pgp_key_path` as default path or add it to all `iam-users.tfvar` files as a variables.


```sh
cd terraform && mkdir keys && cd keys
gpg --output public-key-binary.gpg --export hello@murshidazher.com
```

### Note

One of the problems that we face now is that GPG gets “confused” when we pipe things into it, so before doing so, we need to tell it that we are going to pipe an encrypted message into it:

```sh
export GPG_TTY=$(tty)
```

By correctly setting the environment variable GPG_TTY as per above, GPG clearly understands that we are going to pipe a secret into it.

## Provisioning

> ⚠️ It is important to note down the key generated in the output. Which will be required to decrypt the temporary password for iam user created. Only generated during user creation.

See if the terraform script is valid,

```sh
terraform validate
```

Apply the terraform scripts,

```sh
# create Adam's profile
# terraform <command> -var-file="<tfvar_file_location>"
terraform plan -var-file="iam-users/adam.prod.tfvars"
terraform apply -var-file="iam-users/adam.prod.tfvars"

# create David's profile
terraform plan -var-file="iam-users/david.prod.tfvars"
terraform apply -var-file="iam-users/david.prod.tfvars"
```

Get the outputs and decode it using the passphrase used to generate the `pgp` key,

```sh
terraform output -raw iam_user_password | base64 --decode | gpg --decrypt
# gives you the raw console password
terraform output -raw iam_user_secret | base64 --decode | gpg --decrypt
# gives you the raw programmatic access secret
terraform output -raw iam_user_access_key_id
# gives you the programmatic access key_id

## Test

Add the credentials to `~/.aws/config` and `~/.aws/credentials`,

```bash
# ~/.aws/credentials
[adam]
aws_access_key_id = <<iam_user_access_key_id>>
aws_secret_access_key = <<iam_user_access_key_secret gpg decrypted>
```

```bash
# ~/.aws/config
[profile adam]
region=<<default_region>>
output=json
```

Test the console permissions,

> :bulb: Note: Reference to [aws-cli-cheatsheet](https://www.bluematador.com/learn/aws-cli-cheatsheet)

```sh
# should be possible
aws s3api list-buckets --profile adam
# shouldn't be possible
aws ec2 describe-instances  --profile adam
# An error occurred (UnauthorizedOperation) when calling the DescribeInstances operation: You are not authorized to perform this operation.
```

## Teardown

```sh
terraform destroy
```

## LICENSE

[MIT](./LICENSE) &copy; 2021 Murshid Azher.
