# IAM Role for CloudWatch Agent
resource "aws_iam_role" "cloudwatch_agent_role" {
  name               = "EC2CloudWatchAgentRole"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume_role_policy.json
}

data "aws_iam_policy_document" "cloudwatch_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  role       = aws_iam_role.cloudwatch_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# EC2 Instance Profile
resource "aws_iam_instance_profile" "cloudwatch_instance_profile" {
  name = "CloudWatchInstanceProfile"
  role = aws_iam_role.cloudwatch_agent_role.name
}

# Log Group with 7-Day Retention
resource "aws_cloudwatch_log_group" "minecraft_logs" {
  name              = "/minecraft/server"
  retention_in_days = 7
}