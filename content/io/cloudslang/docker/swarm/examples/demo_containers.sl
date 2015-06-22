#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Demo flow for creating containers in a Swarm cluster.
# Creates two containers and displays the total number of containers (including agent containers) in the cluster after each creation.
#
# Inputs:
#   - swarm_manager_ip - IP address of the machine with the Swarm manager container
#   - swarm_manager_port - port used by the Swarm manager container
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - path to private key file
#   - character_set - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for the command to complete
#   - close_session - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false
#   - agent_forwarding - optional - whether to forward the user authentication agent
#   - container_name_1 - name of the first container - Default: tomcat1
#   - image_name_1 - Docker image for the first container - Default: tomcat
#   - container_name_2 - name of the second container - Default: tomcat2
#   - image_name_2 - Docker image for the second container - Default: tomcat
# Results:
#   - SUCCESS - tasks executed successfully
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.docker.swarm.examples

imports:
  swarm: io.cloudslang.docker.swarm
  swarm_examples: io.cloudslang.docker.swarm.examples
  print: io.cloudslang.base.print

flow:
  name: demo_containers
  inputs:
    - swarm_manager_ip
    - swarm_manager_port
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - close_session:
        required: false
    - agent_forwarding:
        required: false
    - container_name_1: "'tomcat1'"
    - image_name_1: "'tomcat'"
    - container_name_2: "'tomcat2'"
    - image_name_2: image_name_1

  workflow:
    - print_cluster_info_1:
        do:
          swarm_examples.print_cluster_info:
            - swarm_manager_ip
            - swarm_manager_port
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - character_set:
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - close_session:
                required: false
            - agent_forwarding:
                required: false

    - print_container_message_1:
        do:
          print.print_text:
            - text: >
                'Creating container in cluster: ' + container_name_1 + ' (' + image_name_1 + ')'

    - run_container_in_cluster_1:
        do:
          swarm.run_container_in_cluster:
            - swarm_manager_ip
            - swarm_manager_port
            - container_name: container_name_1
            - image_name: image_name_1
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - character_set:
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - close_session:
                required: false
            - agent_forwarding:
                required: false

    - print_cluster_info_2:
        do:
          swarm_examples.print_cluster_info:
            - swarm_manager_ip
            - swarm_manager_port
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - character_set:
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - close_session:
                required: false
            - agent_forwarding:
                required: false

    - print_container_message_2:
        do:
          print.print_text:
            - text: >
                'Creating container in cluster: ' + container_name_2 + ' (' + image_name_2 + ')'

    - run_container_in_cluster_2:
        do:
          swarm.run_container_in_cluster:
            - swarm_manager_ip
            - swarm_manager_port
            - container_name: container_name_2
            - image_name: image_name_2
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - character_set:
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - close_session:
                required: false
            - agent_forwarding:
                required: false

    - print_cluster_info_3:
        do:
          swarm_examples.print_cluster_info:
            - swarm_manager_ip
            - swarm_manager_port
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - character_set:
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - close_session:
                required: false
            - agent_forwarding:
                required: false
  results:
    - SUCCESS
    - FAILURE
