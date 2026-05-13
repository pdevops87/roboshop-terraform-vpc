# roboshop-terraform-vpc

order of creation/priority:
1. first create VPC related

assume_role_policy = jsonencode({[converts terraform configuration language into jso format]
Version = "2012-10-17"
Statement = [{
Effect = "Allow"[explicitly grant permission]
Principal = {
Service = "ec2.amazonaws.com"[this is ec2 instance]
}
Action = "sts:AssumeRole"
}]
})
}
==
for the above 
assume role policy is a trust policy who can access this role[which principal/service is allowed to assume the role]
here role can access by ec2 service and action is sts:AssumeRole

STS = Security Token Service
It generates:

temporary access keys
temporary secret keys
session tokens

what is policy arn and principal arn?
ARN (Amazon Resource Name)
policy arn:arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess this policies are predefined policy 
principal arn: 

Policy ARN: Identifies a list of rules (What can be done).Principal ARN: Identifies the identity (Who is doing it).

create a role: principal arn
create a policy : policy arn 
instance profile arn: create by a role
iam role is for granting permissions to allow other services to run in aws cloud platform 


Services that automatically create Service-Linked Roles





