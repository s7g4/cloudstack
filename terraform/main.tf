provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "./modules/networking"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = "${var.aws_region}a"
}

module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
}

module "kms" {
  source = "./modules/kms"

  project_name = var.project_name
  region       = var.aws_region
}
