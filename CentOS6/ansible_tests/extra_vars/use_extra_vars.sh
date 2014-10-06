#!/bin/bash

# Pass key-value pair
ansible-playbook -i hosts site.yml -e 'testvar1=xyz'

# Pass Jason string for a hash variable
ansible-playbook -i hosts site.yml \
  -e '{ "testvar2": { "name1":"xyz", "name2":"stu" } }'

