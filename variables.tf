variable "lambda_role_name" {
  description = "value"
  type        = string
}
variable "region" {
  description = "value"
  type        = string
}
variable "no_of_functions" {
  description = "value"
  type        = number
}

variable "iam_policy_for_lambda_name" {
  description = "value"
  type        = string
}
variable "runtime" {
  description = "value"
  type        = string
}
variable "handler" {
  description = "value"
  type        = string
}
variable "function_name" {
  description = "Bucket object.Should be a zip file."
  type        = list (string)
}
variable "role_arn" {
     description = "value"
     type = string
}