#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.http

imports:
  lists: io.cloudslang.base.lists

flow:
  name: test_http_client_put

  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
    - content_type:
        default: "application/json"
        private: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - body:
        default: ${'{"id":' + resource_id + ',"name":"' + resource_name + '_updated","status":"sold"}'}
        private: true

  workflow:
    - put:
        do:
          http_client_put:
            - url
            - username
            - password
            - content_type
            - proxy_host
            - proxy_port
            - body
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_results
          - FAILURE: HTTP_CLIENT_PUT_FAILURE

    - check_results:
        do:
          lists.compare_lists:
            - list_1: ${ [str(error_message), int(return_code), int(status_code)] }
            - list_2: ["", 0, 200]
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULTS_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - HTTP_CLIENT_PUT_FAILURE
    - CHECK_RESULTS_FAILURE
