variable "env" {
  description = "The environment you are deploying to: dev, staging, prod, personal, etc"
}

variable "app_name" {
  description = "The name and/or purpose of the application you are running via lambda"
}

variable "interval" {
  description = "Expression for interval. Example: 1 minute, 2 minutes, 1 hour, 2 hours, etc"
}

variable "slack_webhook" {
  description = "The webhook for posting alerts in Slack"
}

variable "runtime" { 
  description = "Runtime environment for the Lambda. Ex: python2.7, python3.6, etc"
}