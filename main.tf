#provider block

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

#Create EC2 instance
resource "aws_instance" "TestInstance1" {
  ami             = "ami-09052aa9bc337c78d"
  instance_type   = "t2.micro"
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
      "sudo mkdir flaskapp",
      "sudo cd flaskapp",
      "sudo git init",
      "sudo git clone https://github.com/ShivaniAgrawal049/TerraformResource.git",
      "sudo PGPASSWORD=postgres psql -h ${aws_db_instance.postgresql.endpoint} -p 5432 -U postgres",
      "\c lecture",
      "CREATE TABLE USERDATA (FNAME VARCHAR NOT NULL , LNAME VARCHAR NOT NULL , EMAIL TEXT NOT NULL ,USERNAME VARCHAR NOT NULL UNIQUE , PASSWORD TEXT NOT NULL);",
      "CREATE TABLE BOOKS (ISBN VARCHAR NOT NULL UNIQUE,TITLE VARCHAR NOT NULL,AUTHOR VARCHAR NOT NULL,PUBYEAR INTEGER NOT NULL);",
      "CREATE TABLE BOOK_RATING(ISBN VARCHAR NOT NULL ,USERNAME VARCHAR NOT NULL ,RATING INTEGER NOT NULL);",
      "CREATE TABLE BOOK_REVIEW(ISBN VARCHAR NOT NULL,USERNAME VARCHAR NOT NULL,REVIEW TEXT NOT NULL);",
      "\copy BOOKS FROM '/home/ec2-user/flaskapp/aws-hackathon/books.csv' DELIMITER ',' CSV",
      "\q",
      "docker-compose up --build"
    ]
  }

