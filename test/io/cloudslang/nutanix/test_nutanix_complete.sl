#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.nutanix

imports:
  utils: io.cloudslang.base.utils
  print: io.cloudslang.base.print
  nutanix: io.cloudslang.nutanix

flow:
  name: test_nutanix_complete
  inputs:
    - name
    - num_vcpus
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
    - description:
        required: false
    - ha_priority:
        required: false
    - num_cores_per_vcpu:
        required: false
  workflow:
    - nutanixCreateResourceVMClone:
        do:
          nutanix.beta_create_resource_vmclonedto:
            - name
            - num_vcpus
            - memory_mb
            - uuid
        publish:
          - return_result
          - response
          - error_message
        navigate:
          - SUCCESS: nutanix_create_resource_vm_create
          - FAILURE: FAILURE

    - nutanix_create_resource_vm_create:
        do:
          nutanix.beta_create_resource_vmcreatedto:
            - name
            - memory_mb
            - num_vcpus
            - description
            - ha_priority
            - num_cores_per_vcpu
            - uuid
        publish:
          - return_result
          - response
          - error_message
        navigate:
          - SUCCESS: nutanix_create_vm
          - FAILURE: FAILURE

    - nutanix_create_vm:
        do:
          nutanix.beta_vms_create:
            - host
            - port
            - username
            - password
            - template_id
            - body: ${response}
        publish:
          - return_result
          - response
          - error_message
        navigate:
          - SUCCESS: nutanix_clone_vm
          - FAILURE: FAILURE

    - nutanix_clone_vm:
        do:
          nutanix.beta_vms_clone:
            - host
            - port
            - username
            - password
            - template_id
            - body: ${response}
        publish:
          - return_result
          - response
          - error_message
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - return_result
    - response
    - error_message
    
  results:
    - SUCCESS
    - FAILURE

