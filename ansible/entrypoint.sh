#! /bin/bash

ansible-playbook playbooks/node.yaml \
    -u root \
    --private-key=~/.ssh/ansible \
    -i playbooks/hosts.ini

# ansible-playbook playbooks/ping.yaml \
#     -u root \
#     --private-key=~/.ssh/ansible \
#     -i playbooks/hosts.ini
