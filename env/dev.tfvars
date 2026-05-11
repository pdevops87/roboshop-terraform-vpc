vpc_cidr="10.0.0.0/22"
env="dev"
public_subnets="10.0.0.0/24"
private_subnets=["10.0.1.0/24","10.0.2.0/24"]
default_vpc_id="vpc-02a94ee8944923438"
default_vpc_cidr_block="172.31.0.0/16"
default_route_table_id="rtb-0a2e9ff93585c96fd"
availability_zone = ["us-east-1a","us-east-1b"]
components = {
  mongodb = {
    ssh_port = 22
    port = 27017
    instance_type = "t3.micro"

  }
#   redis = {
#     port = 6379
#     instance_type="t3.micro"
#   }
#   mysql = {
#     port = 3306
#     instance_type="t3.micro"
#   }
#   rabbitmq = {
#     port = 5672
#     instance_type="t3.micro"
#   }
}
ami="ami-0220d79f3f480ecf5"
zone_id="Z08520602FC482APPVUI7"
lb_subnets=["10.0.0.0/25","10.0.1.0/25"]
bastion_node="54.84.114.1"


# here availability zone means data center