// Resources required for continuously deploying hubs to this cluster
resource "aws_iam_user" "continuous_deployer" {
  name = "hub-continuous-deployer"
  tags = var.tags
}

resource "aws_iam_access_key" "continuous_deployer" {
  user = aws_iam_user.continuous_deployer.name
}

resource "aws_iam_user_policy" "continuous_deployer" {
  name = "eks-readonly"
  user = aws_iam_user.continuous_deployer.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "eks:DescribeCluster",
      "Resource": "${data.aws_eks_cluster.cluster.arn}"
    }
  ]
}
EOF
}


locals {
  cd_creds = {
    "AccessKey" = {
      "UserName" : aws_iam_user.continuous_deployer.name,
      "AccessKeyId" : aws_iam_access_key.continuous_deployer.id,
      "SecretAccessKey" : aws_iam_access_key.continuous_deployer.secret
    }
  }
}

output "continuous_deployer_creds" {
  value     = jsonencode(local.cd_creds)
  sensitive = true
}

output "eksctl_iam_command" {
  description = "eksctl and aws commands to grant cluster access to our CD"
  value       = <<-EOT
   eksctl create accessentry \
      --cluster ${var.cluster_name} \
      --region ${var.region} \
      --principal-arn ${aws_iam_user.continuous_deployer.arn} \
      --kubernetes-username ${aws_iam_user.continuous_deployer.name}
   aws eks associate-access-policy \
      --cluster-name ${var.cluster_name} \
      --region ${var.region} \
      --principal-arn ${aws_iam_user.continuous_deployer.arn} \
      --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy \
      --access-scope type=cluster \
      --no-cli-pager
  EOT
}
