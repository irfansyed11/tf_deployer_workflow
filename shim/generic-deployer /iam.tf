data "aws_iam_policy" "read_ec2" {
  name = "AmazonEC2ReadOnlyAccess"
}

data "aws_iam_policy" "smm_core" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "cloudwatch_agent" {
  name = "CloudWatchAgentServerPolicy"
}

data "aws_iam_policy" "ec2_devops_secrets_policy" {
  name = "ec2_devops_secret_manager_access"
}

resource "aws_iam_role" "ec2_iam_role" {
  name = "${var.deployment_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name          = "${var.deployment_name}-ec2-role"
    terraform     = "True"
    product       = var.product_name
    description   = "This is iam role ${var.deployment_name}-ec2-role for vpc ${nonsensitive(data.aws_ssm_parameter.vpc_id.value)}."
    business_unit = var.business_unit
    resource_type = "IAM Role"
    stack_name    = var.stack_name
    fqhn          = "N/A"
    sortable_name = "${var.deployment_name}-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_iam_role_ec2_access" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = data.aws_iam_policy.read_ec2.arn
}

resource "aws_iam_role_policy_attachment" "ec2_iam_role_s3_access" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = data.aws_iam_policy.full_s3.arn
}

resource "aws_iam_role_policy_attachment" "ec2_iam_role_ssm_access" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = data.aws_iam_policy.smm_core.arn
}

resource "aws_iam_role_policy_attachment" "ec2_iam_role_cloudwatch_agent" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = data.aws_iam_policy.cloudwatch_agent.arn
}

resource "aws_iam_role_policy_attachment" "ec2_iam_role_secrets_access" {
  role       = aws_iam_role.ec2_iam_role.name
  policy_arn = data.aws_iam_policy.ec2_devops_secrets_policy.arn
}

resource "aws_iam_instance_profile" "ec2_iam_profile" {
  name = "${var.deployment_name}-ec2-iam-profile"
  role = aws_iam_role.ec2_iam_role.name
}

output "tg_arns" {
  depends_on = [module.generic_deployer]
  value      = !var.use_path_based_listener ? var.use_external_load_balancer_listner ? module.generic_deployer.ext_lb_target_group_arn : module.generic_deployer.lb_target_group_arn : module.generic_deployer.ext_lb_tg_path_based_arn
}

resource "null_resource" "wait_for_health_check" {
  count      = var.validate_tg_health == true ? 1 : 0
  depends_on = [module.generic_deployer]
  triggers = {
    execute_after = timestamp()
  }

  provisioner "local-exec" {
    command = "sleep ${var.service_health_check_wait}" # Wait for 10 minutes (600 seconds)
  }
}

resource "null_resource" "health_check_trigger" {
  depends_on = [null_resource.wait_for_health_check]

  # This resource does nothing on its own but serves as a trigger
  triggers = {
    execute_after = timestamp()
  }

  for_each = var.validate_tg_health == true ? { for key, tg_arn in !var.use_path_based_listener ? var.use_external_load_balancer_listner ? module.generic_deployer.ext_lb_target_group_arn : module.generic_deployer.lb_target_group_arn : module.generic_deployer.ext_lb_tg_path_based_arn : key => tg_arn } : {}

  provisioner "local-exec" {
    # Command to execute your shell script for each target group
    command = <<-EOT
      tg_status=$(aws elbv2 describe-target-health --target-group-arn "${each.value}" --query "TargetHealthDescriptions[0].TargetHealth.State" --output text)
      echo "\nTG ARN - \"${each.value}\" is \"$tg_status"\"
      if [ "$tg_status" = "healthy" ]; then
        echo "Target Group health check passed, Deployment is successful.\n"
      else
        echo "Target Group health check is not healthy, Marking deployment as failed.\n"
        exit 1
      fi
    EOT
  }
}
