#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.nutanix

imports:
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  nutanix: io.cloudslang.nutanix

flow:
  name: test_vms_clone

  inputs:
    - name
    - num_v_cpus
    - memory_mb
    - uuid
    - host
    - port
    - username
    - password
    - template_id
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true

  workflow:
    - nutanix_create_resource_vm_clone:
        do:
          nutanix.beta_create_resource_vmclonedto:
            - name
            - num_vcpus
            - memory_mb
            - uuid
        publish:
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: check_result
          - FAILURE: CREATE_RESOURCE_VMCLONEDTO

    - check_result:
        do:
          lists.compare_lists:
            - list_1: 'str(error_message), int(return_code)'
            - list_2: '"''", 0'
        navigate:
          - SUCCESS: nutanix_clone_vm
          - FAILURE: CHECK_RESPONSES_FAILURE

    - nutanix_clone_vm:
        do:
          nutanix.beta_vms_clone:
            - host
            - port
            - username
            - password
            - template_id
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - body: ${return_result}
        publish:
          - return_result
          - response
          - error_message
          - response_body: ${return_result}
        navigate:
          - SUCCESS: check_result2
          - FAILURE: CLONE_VM

    - check_result2:
        do:
          lists.compare_lists:
            - list_1: 'str(error_message), int(return_code), int(status_code)'
            - list_2: '"''", 0, 200'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESPONSES_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - CHECK_RESPONSES_FAILURE
    - CREATE_RESOURCE_VMCLONEDTO
    - CLONE_VM