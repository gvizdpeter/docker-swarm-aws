ARG TERRAFORM_VERSION

ARG PACKER_VERSION

FROM hashicorp/terraform:${TERRAFORM_VERSION} as terraform

FROM hashicorp/packer:${PACKER_VERSION}

RUN apk add --no-cache apache2-utils openssh-client

COPY --from=terraform /bin/terraform /bin/terraform

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod a+x /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
