#!/bin/sh

eval `ssh-agent -s`
ssh-add ssh/swarmkey 
ssh -oStrictHostKeyChecking=no -A ubuntu@$(cat txt-files/ip-bastion.txt)