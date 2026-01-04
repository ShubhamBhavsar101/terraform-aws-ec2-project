resource "aws_iam_role" "ec2_role" {
  name = "role-ec2-secrets-readwrite"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "ssm_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "secrets_manager_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_instance_profile" "secrets_manager_profile" {
  name = "ec2-secrets-profile"
  role = aws_iam_role.ec2_role.name
}

output "secrets_manager_instance_profile" {
    value = aws_iam_instance_profile.secrets_manager_profile.name
}
