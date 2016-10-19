#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################

namespace: io.cloudslang.cloud.amazon_aws.images

imports:
  images: io.cloudslang.cloud.amazon_aws.images
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_get_launch_permission_for_image_in_region

  inputs:
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        default: ''
        required: false
    - credential:
        default: ''
        required: false
    - proxy_host:
        default: ''
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - debug_mode:
        default: 'false'
        required: false
    - image_id
    - version

  workflow:
    - get_launch_permissions:
        do:
          images.get_launch_permission_for_image:
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - debug_mode
            - image_id
            - version
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_results
          - FAILURE: GET_LAUNCH_PERMISSIONS_FAILURE

    - check_results:
        do:
          lists.compare_lists:
            - list_1: ${return_code + "," + str(exception)}
            - list_2: "0,"
        navigate:
          - SUCCESS: check_message
          - FAILURE: CHECK_RESULTS_FAILURE

    - check_message:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: ""
        navigate:
          - SUCCESS: NO_RETURN_RESULT
          - FAILURE: SUCCESS

  results:
    - SUCCESS
    - GET_LAUNCH_PERMISSIONS_FAILURE
    - CHECK_RESULTS_FAILURE
    - NO_RETURN_RESULT
