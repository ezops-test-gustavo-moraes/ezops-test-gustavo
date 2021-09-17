provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "ec2-ezops" {
    ami = "${var.amis["us-east-1-ubuntu18"]}"
    instance_type = "${var.instance_type.micro}"
    key_name = "ezops-test-key" 
    tags = {
        Name = "ezops-test-machine"
    }
    vpc_security_group_ids = ["${aws_security_group.ezops-secure.id}"]

    provisioner "remote-exec" {
        inline = [
            "sudo apt update",
            "yes Y | sudo apt install apt-transport-https ca-certificates curl software-properties-common",
            "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
            "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'",
            "sudo apt update",
            "apt-cache policy docker-ce",
            "yes Y | sudo apt install docker-ce",
            "sudo docker pull gustavomoraesfonseca/ezops-test:v1",
            "sudo docker run --restart always -d -p 3000:3000 gustavomoraesfonseca/ezops-test:v1"
        ]
        connection {
            type = "ssh"
            user = "ubuntu"
            private_key = "${file("~/.ssh/id_rsa")}"
            host = "${self.public_ip}"
        }
  }

}