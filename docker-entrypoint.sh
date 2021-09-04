#!/bin/sh

set -eu

export TF_VAR_AUTH_PASSWORD=$(htpasswd -nbB admin "${AUTH_PASSWORD}" | cut -d ":" -f 2 | head -1)

terraform init \
    -input=false \
    -backend-config="bucket=${S3_BACKEND_BUCKET}" \
    -backend-config="key=${S3_BACKEND_KEY}"

terraform validate
#terraform apply -input=false -target=${PACKER_RESOURCE_NAME}
#terraform plan -input=false -out=tf.plan

tail -f /dev/null