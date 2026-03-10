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

module "compute" {
  source = "./modules/compute"

  project_name         = var.project_name
  vpc_id               = module.networking.vpc_id
  public_subnet_ids    = [module.networking.public_subnet_id]
  ami_id               = "ami-0c7217cdde317cfec" 
  instance_type        = var.ec2_instance_type
  iam_instance_profile = module.iam.instance_profile_name
  user_data            = file("${path.module}/../scripts/user_data.sh")
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  desired_capacity     = var.asg_min_size
}

module "database" {
  source          = "./modules/database"
  project_name    = var.project_name
  vpc_id          = module.networking.vpc_id
  subnet_ids      = [module.networking.private_subnet_id]
  db_password     = var.db_password
  app_sg_id       = module.compute.web_sg_id
  kms_key_arn     = module.kms.key_arn
  multi_az        = false
  instance_class  = "db.t3.micro"
}
