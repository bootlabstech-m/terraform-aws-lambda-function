resource "aws_iam_role" "lambda_role" {
name   = var.lambda_role_name
assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  lifecycle {
    ignore_changes = [tags]
  }
}
resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = var.iam_policy_for_lambda_name
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
  lifecycle {
    ignore_changes = [tags]
  }
}
 
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}
 
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/python/hello-python.zip"
}
 
resource "aws_lambda_function" "terraform_lambda_func" {
count                          = var.no_of_functions
filename                       = "${path.module}/python/hello-python.zip"
function_name                  = var.name[count.index]
role                           = aws_iam_role.lambda_role.arn
handler                        = var.handler
runtime                        = var.runtime
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
memory_size                    = var.memory_size
timeout                        = var.timeout 
  lifecycle {
    ignore_changes = [tags]
  }
}