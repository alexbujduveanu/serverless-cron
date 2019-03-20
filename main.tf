resource "aws_lambda_function" "cron_task" {
    filename = "${path.module}/files/lambda.zip"
    function_name = "lambda_handler"
    role = "${aws_iam_role.instance.arn}"
    runtime = "${var.runtime}"
    handler = "lambda.lambda_handler"
}

resource "aws_cloudwatch_event_rule" "fire_on_interval" {
    name = "every-five-minutes"
    description = "Fires every X minutes/hours/days"
    schedule_expression = "rate(${var.interval})"
}

resource "aws_cloudwatch_event_target" "cron_task_every_five_minutes" {
    rule = "${aws_cloudwatch_event_rule.every_five_minutes.name}"
    target_id = "cron_task"
    arn = "${aws_lambda_function.cron_task.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_cron_task" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.cron_task.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.fire_on_interval.arn}"
}


data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  name               = "instance_role"
  path               = "/system/"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name = "lambda_logs"

  tags = {
    Environment = "${var.env}"
    Application = "${var.app_name}"
  }
}

