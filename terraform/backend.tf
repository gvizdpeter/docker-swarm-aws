terraform {
  backend "s3" {
    bucket = "terraform-remote-state"
    key    = "docker-swarm-aws/terraform.tfstate"
  }
}