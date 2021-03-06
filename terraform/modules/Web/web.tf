resource "aws_instance" "web" {
    ami = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    tags {
        Name = "theweb"
        env = "${var.env}"
    }
   key_name = "drvishwas"
   security_groups = ["${aws_security_group.sgWeb.name}"]
   
}




resource "aws_security_group" "sgWeb" {
    name  = "sgWeb"
    tags {
        Name = "sgWeb"
    }
    ingress {
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = "3000"
        to_port = "3000"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
   
}