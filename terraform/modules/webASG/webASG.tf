resource "aws_launch_configuration" "webLC" {
   image_id  = "${var.imageid}"
   instance_type = "${var.instancetype}"
   security_groups = ["${aws_security_group.sgWebSSH.id}"]
   lifecycle {
       create_before_destroy = true
   }

   key_name = "drvishwas"
   user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y nodejs --enablerepo=epel
              wget http://bit.ly/2vESNuc -O /home/ec2-user/helloworld.js
              wget http://bit.ly/2vVvT18 -O /etc/init/helloworld.conf
              start helloworld
              EOF
}

resource "aws_autoscaling_group" "webAsg" {
    launch_configuration = "${aws_launch_configuration.webLC.id}"
    min_size = 3
    max_size = 3
    availability_zones = [ "${data.aws_availability_zones.all.names}"]
    load_balancers = ["${aws_elb.myelb.id}"]
    
}


resource "aws_elb" "myelb" {
    security_groups = ["${aws_security_group.sgElb.id}"]
    availability_zones = ["${data.aws_availability_zones.all.names}"]
    listener {
           lb_port = "8000"
            lb_protocol = "http"
            instance_port = "8000"
            instance_protocol  = "http"

    }
   

}

data "aws_availability_zones" "all" {}

resource "aws_security_group" "sgElb" {
    ingress {
        from_port = "8000"
        to_port  = "8000"
        protocol  = "tcp"
        cidr_blocks=  ["0.0.0.0/0"]
    }
     egress {
        from_port = 0
        to_port  = 0
        protocol  = -1
        cidr_blocks=  ["0.0.0.0/0"]
    }
}


resource "aws_security_group" "sgWebSSH" {
    ingress {
        from_port = "8000"
        to_port = "8000"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    ingress {
        from_port = "22"
        to_port = "22"
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


 