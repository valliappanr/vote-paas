variable "account_id" {
description = "account id"
}

variable "region" {
  description = "Region"
  default     = "eu-west-2"
}

variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "10.1.0.0/16"
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "namespace" {
  description = "Default namespace"
  default = "voting-namespace"
}

variable "cluster_id" {
  description = "Id to assign the new cluster"
  default = "redis-cache"
}


variable "node_groups" {
  description = "Number of nodes groups to create in the cluster"
  default     = 1
}

variable "lambda_payload_filename" {
  default = "target/voting-system-1.0-SNAPSHOT.jar"
}

variable "lambda_payload_result_filename" {
  default = "target/voting-system-1.0-SNAPSHOT.jar"
}

variable "lambda_function_handler" {
  default = "aws.VotingConsumer::handleRequest"
}

variable "lambda_nominees_function_handler" {
  default = "aws.NomineeRequest::handleRequest"
}

variable "lambda_voting_result_function_handler" {
  default = "aws.VotingResult::handleRequest"
}

variable "lambda_runtime" {
  default = "java11"
}

variable "campaign_file_name" {
  default = "nominee_bbc_radio4.json"
}

