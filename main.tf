provider "aws" {
  region     = "ap-south-1"
}

#Create Postgresql
resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "10.6"
  instance_class       = "db.t2.micro"
  name                 = "TerraformDb"
  username             = "postgres"
  password             = "postgres"
  port                 = "5432"
  publicly_accessible  = true
  auto_minor_version_upgrade = true
  tags = {
    Name = "TerraformCreatedDB"
    }
}

resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
  key_name      = "InstanceAWS"
}

output "instance_public_dns"{
  value = aws_instance.web.public_dns
  }

