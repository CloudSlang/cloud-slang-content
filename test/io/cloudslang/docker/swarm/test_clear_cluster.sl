#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
# Wrapper test flow - checks whether the Swarm cluster is clean (in that case starts a container in the
# cluster so the cluster will contain at least one container that is not Swarm agent), clears the cluster
# and verifies that the number of containers in the cluster is the number of agent containers.
########################################################################################################

namespace: io.cloudslang.docker.swarm

imports:
  strings: io.cloudslang.base.strings

flow:
  name: test_clear_cluster
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
    - timeout:
        required: false
    - container_name: "'tomi'"
    - image_name: "'tomcat'"
    - number_of_agent_containers_in_cluster
    - agent_machine_ip

  workflow:
    - setup_cluster:
        do:
          test_add_node_to_cluster:
            - manager_machine_ip: swarm_manager_ip
            - manager_machine_username: username
            - manager_machine_password:
                default: password
                required: false
            - manager_machine_private_key_file:
                default: private_key_file
                required: false
            - swarm_manager_port
            - agent_machine_ip
            - agent_machine_username: username
            - agent_machine_password:
                default: password
                required: false
            - agent_machine_private_key_file:
                default: private_key_file
                required: false
        navigate:
          SUCCESS: get_number_of_containers_in_cluster_before
          CREATE_SWARM_CLUSTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          PRE_CLEAR_MANAGER_MACHINE_PROBLEM: SETUP_CLUSTER_PROBLEM
          PRE_CLEAR_AGENT_MACHINE_PROBLEM: SETUP_CLUSTER_PROBLEM
          START_MANAGER_CONTAINER_PROBLEM: SETUP_CLUSTER_PROBLEM
          GET_NUMBER_OF_NODES_IN_CLUSTER_BEFORE_PROBLEM: SETUP_CLUSTER_PROBLEM
          ADD_NODE_TO_THE_CLUSTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          GET_NUMBER_OF_NODES_IN_CLUSTER_AFTER_PROBLEM: SETUP_CLUSTER_PROBLEM
          VERIFY_NODE_IS_ADDED_PROBLEM: SETUP_CLUSTER_PROBLEM

    - get_number_of_containers_in_cluster_before:
        do:
          get_cluster_info:
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
            - timeout:
                required: false
        publish:
          - number_of_containers_in_cluster_before: number_of_containers_in_cluster
        navigate:
          SUCCESS: check_cluster_is_clean
          FAILURE: GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_BEFORE_PROBLEM

    - check_cluster_is_clean:
        do:
          strings.string_equals:
            - first_string: str(number_of_containers_in_cluster_before)
            - second_string: str(number_of_agent_containers_in_cluster)
        navigate:
          SUCCESS: run_container_in_cluster
          FAILURE: clear_cluster

    - run_container_in_cluster:
        do:
          run_container_in_cluster:
            - swarm_manager_ip
            - swarm_manager_port
            - container_name
            - image_name
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
        navigate:
          SUCCESS: clear_cluster
          FAILURE: RUN_CONTAINER_IN_CLUSTER_PROBLEM

    - clear_cluster:
       do:
         clear_cluster:
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
            - timeout:
                required: false
       navigate:
         SUCCESS: get_number_of_containers_in_cluster_after
         FAILURE: CLEAR_CLUSTER_PROBLEM

    - get_number_of_containers_in_cluster_after:
        do:
          get_cluster_info:
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
            - timeout:
                required: false
        publish:
          - number_of_containers_in_cluster_after: number_of_containers_in_cluster
        navigate:
          SUCCESS: verify_cluster_is_cleared
          FAILURE: GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_AFTER_PROBLEM

    - verify_cluster_is_cleared:
        do:
          strings.string_equals:
            - first_string: str(number_of_agent_containers_in_cluster)
            - second_string: str(number_of_containers_in_cluster_after)
        navigate:
          SUCCESS: SUCCESS
          FAILURE: VERIFY_CLUSTER_IS_CLEARED_PROBLEM
  results:
    - SUCCESS
    - CLEAR_CLUSTER_PROBLEM
    - SETUP_CLUSTER_PROBLEM
    - GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_BEFORE_PROBLEM
    - RUN_CONTAINER_IN_CLUSTER_PROBLEM
    - GET_NUMBER_OF_CONTAINERS_IN_CLUSTER_AFTER_PROBLEM
    - VERIFY_CLUSTER_IS_CLEARED_PROBLEM
