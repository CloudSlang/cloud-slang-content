#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##########################################################################################################################################################
#   Runs the docker_images_maintenance flow against all the machines in the cluster.
#
#   Inputs:
#       - coreos_host - CoreOS machine host - can be any machine from the cluster
#       - coreos_username - CoreOS machine username
#       - private_key_file - the absolute path to the private key file; Default: none
#       - percentage - if disk space is greater than this value then unused images will be deleted - ex. (50%) - Default: 0%
#   Outputs:
#       - number_of_deleted_images_per_host - String that contains how many images were deleted for every host - Format: "ip1: number1, ip2: number2"
#       - error_Message - possible error message
##########################################################################################################################################################

namespace: org.openscore.slang.coreos

imports:
 coreos: org.openscore.slang.coreos
 maintenance: org.openscore.slang.docker.maintenance

flow:
  name: cluster_docker_images_maintenance

  inputs:
    - coreos_host
    - coreos_username
    - coreos_password:
        default: "''"
        overridable: false
    - private_key_file
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
            - coreos_password
            - private_key_file
        publish:
            - machines_public_ip_list
            - error_message

    - loop_docker_images_maintenance:
          loop:
              for: machine_public_ip in machines_public_ip_list.split(' ')
              do:
                  maintenance.docker_images_maintenance:
                    - docker_host: machine_public_ip
                    - docker_username: coreos_username
                    - docker_password: coreos_password
                    - private_key_file
                    - percentage
              publish:
                    - number_of_deleted_images_per_host: >
                        fromInputs['number_of_deleted_images_per_host'] + fromInputs['machine_public_ip'] + ': ' + total_amount_of_images_deleted + ','

  outputs:
    - number_of_deleted_images_per_host: number_of_deleted_images_per_host[:-1]
    - error_message
