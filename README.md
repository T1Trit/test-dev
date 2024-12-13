analyze-deb.sh - for 1 task
ftp-deployment.yml - for 2 task
for 3 task i create zip arch. 
//to run it :
Setup Ansible:
sudo apt update && sudo apt install ansible -y
Prepare Inventory: Create an inventory file in the playbook directory:
[app_servers]
<SERVER_IP> ansible_user=<USER> ansible_ssh_private_key_file=<SSH_KEY_PATH>
Run Playbook:
ansible-playbook -i inventory site.yml
//and if need 
PostgreSQL: Verify database:
psql -U postgres -h <SERVER_IP> -c "\l"
