#provider block

provider "aws" {
  #access_key = "${var.access_key}"
  #secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

#Create Postgresql
resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "${var.engine_version}"
  instance_class       = "${var.db_instance_type}"
  name                 = "TerraformDb"
  username             = "${var.database_username}"
  password             = "${var.database_password}"
  port                 = "${var.database_port}"
  publicly_accessible  = true
  auto_minor_version_upgrade = true
  tags = {
    Name = "TerraformCreatedDB"
    }
}

#Create EC2 instance
resource "aws_instance" "TestInstance1" {
  ami             = "ami-09052aa9bc337c78d"
  instance_type   = "${var.instance_type}"
  count = 1
  key_name = "awskey1"
  tags = {
    Name = "TerraformCreatedInstance"
  }

   connection {
    type = "ssh"
    user = "ec2-user"
    host = "${self.public_ip}"
    private_key = "${file("awskey1.pem")}"
  }
  
  #provisioners - remote-exec 
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y git",
      "sudo yum install -y docker",
      "sudo yum install -y postgresql",
      "sudo yum install -y docker",
      "sudo yum install -y unzip",
      "wget https://releases.hashicorp.com/terraform/0.13.2/terraform_0.13.2_linux_amd64.zip",
      "sudo unzip terraform_0.13.2_linux_amd64.zip",
      "echo $"export PATH=\$PATH:$(pwd)" >> ~/.bash_profile"'
      "source ~/.bash_profile",
      "sudo mkdir flaskapp",
      "sudo cd flaskapp",
      "sudo git init",
      "sudo git clone https://github.com/ShivaniAgrawal049/TerraformResource.git",
      "sudo PGPASSWORD=${var.database_password} psql -h ${aws_db_instance.postgresql.endpoint} -p 5432 -U ${var.database_username}",
      "\c lecture",
      "CREATE TABLE USERDATA (FNAME VARCHAR NOT NULL , LNAME VARCHAR NOT NULL , EMAIL TEXT NOT NULL ,USERNAME VARCHAR NOT NULL UNIQUE , PASSWORD TEXT NOT NULL);",
      "CREATE TABLE BOOKS (ISBN VARCHAR NOT NULL UNIQUE,TITLE VARCHAR NOT NULL,AUTHOR VARCHAR NOT NULL,PUBYEAR INTEGER NOT NULL);",
      "CREATE TABLE BOOK_RATING(ISBN VARCHAR NOT NULL ,USERNAME VARCHAR NOT NULL ,RATING INTEGER NOT NULL);",
      "CREATE TABLE BOOK_REVIEW(ISBN VARCHAR NOT NULL,USERNAME VARCHAR NOT NULL,REVIEW TEXT NOT NULL);",
      "\copy BOOKS FROM '/home/ec2-user/flaskapp/aws-hackathon/books.csv' DELIMITER ',' CSV",
      "\q"
    ]
  }

