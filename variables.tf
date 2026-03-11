variable "ami_id" {
  default = "ami-0220d79f3f480ecf5"
}

variable "tools" {
  default = {
    vault={
      instance_type = "t3.small"
      port = 8200
      zone_id = "Z08819072319VLT801BHA"
    }
  }
}

variable "github-runner" {
  default = {
    github-runner={
      instance_type = "t3.small"
      zone_id = "Z08819072319VLT801BHA"
      vpc_security_group_ids = ["sg-043ff9d2da877c20a"]
    }
  }
}

