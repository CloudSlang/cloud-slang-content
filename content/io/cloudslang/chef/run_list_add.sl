#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Adds a set of Chef roles and/or recipes to a node's run list
#
# Inputs:
#   - run_list_items - a list of roles and/or recipes to be added
#                      see https://docs.chef.io/knife_node.html#run-list-add
#   - node_name - name of the node to assign cookbooks to
#   - knife_host - server with configured knife accessable via SSH, can be main Chef server
#   - knife_username - SSH username to access server with knife
#   - knife_password - optional - if using password auth
#   - knife_privkey - optional - SSH keyfile, if using keyfile auth  (local file that resides where flow is executing)
#   - knife_config - optional - location of knife.rb config file, default ~/.chef/knife.rb
# Outputs:
#   - knife_result - filtered output of knife command
#   - raw_result - full STDOUT
#   - standard_err - any STDERR
# Results:
#   - SUCCESS - cookbooks were added to the run list
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.chef

flow:
  name: run_list_add
  inputs:
    - run_list_items
    - node_name    
    - knife_host
    - knife_username
    - knife_privkey:
        required: false
    - knife_password: 
        required: false
    - knife_config:
        required: false

  workflow:
    - add_to_run_list:
        do:
          knife_command:
            - knife_cmd: "'node run_list add ' + node_name + ' \\'' + run_list_items + '\\''"
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - raw_result
          - standard_err
          - knife_result

  outputs:
    - knife_result: knife_result
    - raw_result
    - standard_err: standard_err