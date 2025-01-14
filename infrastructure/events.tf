resource "aws_cloudwatch_event_rule" "stop_instance_rule" {
  name                = "StopMinecraftInstance"
  schedule_expression = "cron(0 3 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "stop_instance_target" {
  rule      = aws_cloudwatch_event_rule.stop_instance_rule.name
  target_id = "StopInstance"
  arn       = aws_instance.minecraft_instance.arn
  input     = jsonencode({ "action" : "stop" })
}

resource "aws_cloudwatch_event_rule" "start_instance_rule" {
  name                = "StartMinecraftInstance"
  schedule_expression = "cron(0 16 ? * MON-FRI *)"
}


resource "aws_cloudwatch_event_target" "start_instance_target" {
  rule      = aws_cloudwatch_event_rule.start_instance_rule.name
  target_id = "StartInstance"
  arn       = aws_instance.minecraft_instance.arn
  input     = jsonencode({ "action" : "start" })
}

resource "aws_iam_role" "event_role" {
  name               = "EventBridgeEC2ControlRole"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

data "aws_iam_policy_document" "ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "event_role_policy_attachment" {
  role       = aws_iam_role.event_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_cloudwatch_event_target" "event_target_permissions" {
  rule      = aws_cloudwatch_event_rule.stop_instance_rule.name
  role_arn  = aws_iam_role.event_role.arn
  target_id = aws_instance.minecraft_instance.id
}
