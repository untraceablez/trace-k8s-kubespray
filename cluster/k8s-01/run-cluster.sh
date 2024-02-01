ansible-playbook -i inventory/k8s-01/inventory.ini \
 --become \
 --become-user=root \
 cluster.yml \
 -e "ansible_sudo_pass=torpid-ambience-russia"   