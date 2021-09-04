Host bastion
  HostName ${bastion_ip}
  User ${aws_instance_username}
  IdentityFile ${ssh_swarm_key}
  StrictHostKeyChecking accept-new

Host swarm-leader
  HostName ${swarm_leader_ip}
  User ${aws_instance_username}
  IdentityFile ${ssh_swarm_key}
  StrictHostKeyChecking accept-new
  ProxyCommand ssh bastion -W %h:%p

Host ${private_subnet_wildcard}
  User ${aws_instance_username}
  IdentityFile ${ssh_swarm_key}
  StrictHostKeyChecking accept-new
  ProxyCommand ssh bastion -W %h:%p
