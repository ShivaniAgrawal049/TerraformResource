provider "aws" {
  access_key = "AKIA45MIFH5SF3GKC3FZ"
  secret_key = "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"
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

   connection {
    type = "ssh"
    user = "ec2-user"
    host = aws_instance.web.public_dns
    private_key = ${file("awskey1.pem")}
  }
  
  #provisioners - remote-exec 
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y git",
      "sudo yum install -y docker",
      "sudo yum install -y postgresql",
      "sudo yum install -y docker",
      "sudo mkdir flaskapp",
      "sudo cd flaskapp",
      "sudo git init",
      "sudo git clone https://github.com/ShivaniAgrawal049/TerraformResource.git",
      "sudo PGPASSWORD=postgres psql -h ${aws_db_instance.postgresql.endpoint} -p 5432 -U postgres",
      "docker-compose up --build"
    ]
  }

