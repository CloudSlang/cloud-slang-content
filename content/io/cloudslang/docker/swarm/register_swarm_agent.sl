#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
# Registers the Swarm agent to the discovery service.
#
# Inputs:
#   - node_ip - IP address of the node the agent is running on. The node’s IP must be accessible from the Swarm Manager.
#   - cluster_id - ID of the Swarm cluster
#   - swarm_image - optional - Docker image the Swarm agent container is created from - Default: swarm (latest)
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - path to private key file
#   - character_set - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for the command to complete
#   - close_session - optional - if false SSH session will be cached for future calls during the life of the flow,
#                              - if true the SSH session used will be closed;
#                              - Valid: true, false
#   - agent_forwarding - optional - whether to forward the user authentication agent
# Outputs:
#   - agent_container_ID - ID of the created agent container
########################################################################################################

namespace: io.cloudslang.docker.swarm

imports:
  containers: io.cloudslang.docker.containers

flow:
  name: register_swarm_agent
  inputs:
    - node_ip
    - cluster_id
    - swarm_image:
        default: "'swarm'"
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

  workflow:
    - run_agent_container:
        do:
          containers.run_container:
            - container_command: >
                'join --addr=' + node_ip + ':2375' + ' token://' + cluster_id
            - image_name: swarm_image
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - characterSet:
                default: character_set
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - closeSession:
                default: close_session
                required: false
            - agentForwarding:
                default: agent_forwarding
                required: false
        publish:
          - agent_container_ID: container_ID
  outputs:
    - agent_container_ID
