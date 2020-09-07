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
  
#provisioners - File 
   
  provisioner "file" {
    source      = "playbook.yaml"
    destination = "/tmp/playbook.yaml"

 }

  #provisioners - remote-exec 
  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install  ansible2 -y",
      "sleep 10s",
      "sudo ansible-playbook -i localhost /tmp/playbook.yaml",
      "sudo chmod 657 /var/www/html"
    ]
    
  }

   provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"

 }

