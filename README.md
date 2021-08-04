# docker-swarm-aws
Terraform creation of autoscaled docker swarm in AWS

## Docker compose services

### Packer
After running docker-compose up, packer will download AMI specified by AWS_DEFAULT_AMI_ID env variable, adds docker and efs-utils for mounting shared efs volume (shared volume for all docker swarm nodes).

### Terraform

Terraform will wait for upload of newly created AMI, and then will provision docker swarm, that is accessible on domain specified by TF_VAR_AWS_SWARM_DOMAIN.

All swarm nodes are created in private subnet and are accessible by bastion host, that allows ssh connection only from your ip (env TF_VAR_MY_IP). Private and public key can be found in ssh folder.
All nodes have shared efs volume. Worker nodes are part of autoscaling group with min,max number of workers and low,high threshold for adding/removing nodes.

In public subnet is placed bastion host with load balancer. Wildcard DNS record is pointing to public IP address of load balancer. On load balancer is set ssl termination and traffic is routed to docker swarm managers.

On startup of docker swarm, portainer and traefik stacks are deployed according to files placed in swarm folder. Portainer can be accessed on url https://portainer.your-domain and you can login by credentials admin:${PORTAINER_PASSWORD}. Traefik dashboard can be accessed on url https://traefik.your-domain and metrics can be accessed on url https://traefik.your-domain/metrics.

Before run please check values in .env file and also S3 remote state configuration in terraform/backend.tf. Variable TF_VAR_CREATE_HOSTED_ZONE controls wether to create hosted zone or not. It could be useful if you want to prevent changing AWS name servers.