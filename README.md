# Sandbox Ubuntu Server

 - version 0.1


## Description

### OS Version

create an ubuntu 23.04 server running on a t3.medium ec2 instance

### Infrastructure

 - use launch template and
 - autoscaling group to spin up instance (can be used to create multiple servers in needed)
 - use security_group module to create security groups
 - security group ingress ALL for http/https 
 - security group ports open 8080 (jenkins) and 3000 (RAILS, typescript, react, etc)

## Require

 - ssh public key on aws account, using private key to access 
 - aws iam instance profile (ec2-power-user)

## Parameters

  - us-west-2a (hard-coded for me) 
  
