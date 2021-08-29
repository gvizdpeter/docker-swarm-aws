#!/bin/sh

set -eu

export TF_VAR_AUTH_PASSWORD=$(htpasswd -nb -B admin "${AUTH_PASSWORD}" | cut -d ":" -f 2 | sed 's/\$/$$/g' | head -1)

chmod a+x scripts/connect_bastion.sh

terraform init \
    -input=false \
    -backend-config="bucket=${S3_BACKEND_BUCKET}" \
    -backend-config="key=${S3_BACKEND_KEY}"

terraform validate
#terraform apply -input=false -target=${PACKER_RESOURCE_NAME}
#terraform plan -input=false -out=tf.plan

tail -f /dev/null