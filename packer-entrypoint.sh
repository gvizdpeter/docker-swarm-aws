#!/bin/sh

set -eu

packer build -machine-readable packer-instance.json | tee packer-instance.log
grep -Eo 'ami-[0-9a-z]+' packer-instance.log | tail -1 | head -c -1 > terraform/txt-files/packer-ami.txt
rm packer-instance.log