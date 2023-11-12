data "aws_region" "current_region" {}

data "aws_ami" "ec2_ami" {
  for_each           = local.ec2_instances
  most_recent        = true
  owners             = [each.value.system.ami_owner]
  include_deprecated = true

  filter {
    name   = "name"
    values = [each.value.system.ami_name]
  }
}

data "aws_vpc" "sg_vpc" {
  for_each = local.ec2_sg_config
  filter {
    name   = "tag:Name"
    values = [each.value.vpc_name]
  }
}

data "aws_subnet" "ec2_subnet" {
  for_each = local.ec2_instances

  filter {
    name   = "tag:Name"
    values = [format("%s*",each.value.network.subnet_name)]
  }
}
