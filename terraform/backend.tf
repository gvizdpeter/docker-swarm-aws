terraform {
  backend "s3" {
    bucket = "k8-test-tf"
    key    = "docker-swarm-aws/terraform.tfstate"
  }
}