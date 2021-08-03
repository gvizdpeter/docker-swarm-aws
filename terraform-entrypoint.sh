#!/bin/sh

set -eu

apk add --no-cache gettext apache2-utils
while [ ! -f /home/terraform/${TF_VAR_AWS_AMI_ID_FILE} ]
do
  echo "Waiting for packer"
  sleep 5
done
export TF_VAR_PORTAINER_ADMIN_PASSWORD=$(htpasswd -nb -B admin "${PORTAINER_PASSWORD}" | cut -d ":" -f 2 | sed 's/\$/$$/g' | head -1)
chmod a+x connect_bastion.sh
terraform init -input=false
terraform validate
terraform plan -input=false -out=tf.plan
tail -f /dev/null