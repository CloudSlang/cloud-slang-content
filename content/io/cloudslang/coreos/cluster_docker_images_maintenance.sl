#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Runs the docker_images_maintenance flow against all the machines in the cluster.
#
# Inputs:
#   - coreos_host - CoreOS machine host; can be any machine from the cluster
#   - coreos_username - CoreOS machine username
#   - coreos_password - optional - CoreOS machine password; can be empty since CoreOS machines use private key file authentication
#   - private_key_file - optional - path to the private key file
#   - timeout - optional - time in milliseconds to wait for the command to complete
#   - percentage - if disk space is greater than this value then unused images will be deleted - Example: 50% - Default: 0%
# Outputs:
#   - number_of_deleted_images_per_host - how many images were deleted for every host - Format: "ip1: number1, ip2: number2"
####################################################

namespace: io.cloudslang.coreos

imports:
 coreos: io.cloudslang.coreos
 maintenance: io.cloudslang.docker.maintenance

flow:
  name: cluster_docker_images_maintenance

  inputs:
    - coreos_host
    - coreos_username
    - coreos_password:
        required: false
    - private_key_file:
        required: false
    - timeout:
        required: false
    - percentage:
        default: "'0%'"
    - number_of_deleted_images_per_host:
        default: "''"
        overridable: false

  workflow:
    - list_machines_public_ip:
        do:
          coreos.list_machines_public_ip:
            - coreos_host
            - coreos_username
            - coreos_password:
                required: false
            - private_key_file:
                required: false
            - timeout:
                required: false
        publish:
            - machines_public_ip_list

    - loop_docker_images_maintenance:
          loop:
              for: machine_public_ip in machines_public_ip_list.split()
              do:
                  maintenance.docker_images_maintenance:
                    - docker_host: machine_public_ip
                    - docker_username: coreos_username
                    - docker_password:
                        default: coreos_password
                        required: false
                    - private_key_file:
                        required: false
                    - percentage
                    - timeout:
                        required: false
              publish:
                    - number_of_deleted_images_per_host: >
                        fromInputs['number_of_deleted_images_per_host'] + fromInputs['machine_public_ip'] + ': ' + str(total_amount_of_images_deleted) + ','

  outputs:
    - number_of_deleted_images_per_host: number_of_deleted_images_per_host[:-1]
