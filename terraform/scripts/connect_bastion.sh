#!/bin/sh

eval `ssh-agent -s`
ssh-add ssh/swarmkey
ssh -oStrictHostKeyChecking=no -A ${TF_VAR_AWS_INSTANCE_USERNAME}@$(cat ip-files/ip-bastion.txt)