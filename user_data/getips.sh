#!/usr/bin/bash
aws ec2 describe-instances \
--filters Name=tag:aws:autoscaling:groupName,Values=$ASG \
--query 'Reservations[*].Instances[*].{"public_ip":PupblicIpAddress}' \
--output json


