
#bastion server

resource "aws_instance" "bastion"{
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = var.public1
  vpc_security_group_ids = [var.bastion_security_grp_id]
  key_name               = "taskkp"
  availability_zone      = var.az1
}
#web private server

resource "aws_instance" "private" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = var.private1
  vpc_security_group_ids = [var.web_app_security_grp_id]
  availability_zone      = var.az1
  key_name               =  "taskkp"
  user_data              = <<-EOL
  #!/bin/sh

  sudo apt update -y
  sudo apt install openjdk-11-jdk -y
  sudo apt-get install tomcat9 tomcat9-docs tomcat9-admin -y
  sudo cp -r /usr/share/tomcat9-admin/* /var/lib/tomcat9/webapps/ -v
  udo chmod 777 /var/lib/tomcat9/conf/tomcat-users.xml
  sudo cat <<EOF >> /var/lib/tomcat9/conf/tomcat-users.xml
  <role rolename="manager-script"/>
  <user username="tomcat" password="password" roles="manager-script"/>
  <role rolename="admin-gui"/>
  <role rolename="manager-gui"/>
  <user username="admin" password="admin" roles="admin-gui,manager-gui"/>
  </tomcat-users>
  EOF
  sudo sed -i '44d' /var/lib/tomcat9/conf/tomcat-users.xml
  echo 'clearing screen...' && sleep 5
  clear
  echo 'tomcat is installed'
  sudo systemctl restart tomcat9
  EOL
  
}

# use data source to get a registered ubuntu ami

data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_key_pair" "taskkp" {
  key_name           = "taskkp"
  include_public_key = true
}

data "aws_ec2_instance_type" "instance_type" {
  instance_type = "t2.micro"
}