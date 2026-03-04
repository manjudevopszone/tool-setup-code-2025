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

