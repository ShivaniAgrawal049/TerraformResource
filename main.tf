#provider block

provider "aws" {
  #access_key = "${var.access_key}"
  #secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

#Create EC2 instance
resource "aws_instance" "TestInstance1" {
  ami             = "ami-09052aa9bc337c78d"
  instance_type   = "${var.ec_instance_type}"
  count = 1
  key_name = "awskey1"
  tags = {
    Name = "TerraformCreated"
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

  }

