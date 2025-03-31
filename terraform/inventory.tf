
# Create ansible inventory dynamically 

resource "local_file" "ansible_inventory" {
  filename = "/home/ubuntu/Cluster/k8s.project/ansible/hosts"

  content = <<EOT

[master]
${aws_instance.rke_master.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[worker1]
${aws_instance.rke_worker1.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[worker2]
${aws_instance.rke_worker2.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa

[all:children]
master
workers

[workers]
${aws_instance.rke_worker1.public_ip}
${aws_instance.rke_worker2.public_ip}
EOT
}

# Create jinja vars file dynamically 

resource "local_file" "ansible_vars" {

filename = "/home/ubuntu/Cluster/k8s.project/terraform/inventory.tf"

content = <<EOT

MASTER_IP: ${aws_instance.rke_master.public_ip}
WORKER1_IP: ${aws_instance.rke_worker1.public_ip} 
WORKER2_IP: ${aws_instance.rke_worker2.public_ip}
EOT
}