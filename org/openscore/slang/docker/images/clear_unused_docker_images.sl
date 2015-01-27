#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will delete unused docker images.
#
#   Inputs:
#       - dockerHost - Docker machine host
#       - dockerUsername - Docker machine username
#       - dockerPassword - Docker machine password
#   Outputs:
#       - amount_of_images_deleted - how many images where deleted
#       - amount_of_dangling_images_deleted - how many dangling images where deleted
#       - dangling_images_list_safe_to_delete - list populated with dangling images that are safe to delete
#       - images_list_safe_to_delete - list populated with images that are safe to delete
####################################################

namespace: org.openscore.slang.docker.images

imports:
 docker_images: org.openscore.slang.docker.images
 docker_linux: org.openscore.slang.docker.linux

flow:
  name: clear_unused_docker_images
  inputs:
    - dockerHost
    - dockerUsername
    - dockerPassword
  workflow:
     clear_docker_images:
        do:
          docker_images.clear_docker_images_flow:
            - dockerHost
            - dockerUsername
            - dockerPassword
        publish:
          - images_list_safe_to_delete
          - amount_of_images_deleted
          - used_images_list
     clear_docker_dangling_images:
        do:
          docker_images.clear_docker_dangling_images_flow:
            - dockerHost
            - dockerUsername
            - dockerPassword
            - usedImages: used_images_list
        publish:
          - dangling_images_list_safe_to_delete
          - amount_of_dangling_images_deleted
  outputs:
    - amount_of_images_deleted
    - amount_of_dangling_images_deleted
    - dangling_images_list_safe_to_delete
    - images_list_safe_to_delete
