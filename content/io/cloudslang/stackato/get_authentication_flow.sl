#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Authenticates to a Helion Development Platform / Stackato instance.
#
# Inputs:
#   - host - Helion Development Platform / Stackato instance
#   - username - HDP/Stackato username
#   - password - HDP/Stackato password
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - token - authentication token
#   - return_result - response of the last operation that was executed
#   - error_message - error message of the operation that failed
# Results:
#   - SUCCESS
#   - FAILURE
####################################################

namespace: io.cloudslang.stackato

imports:
 stackato_utils: io.cloudslang.stackato.utils

flow:
  name: get_authentication_flow
  inputs:
    - host
    - username
    - password
    - proxyHost:
        required: false
    - proxyPort:
        required: false
  workflow:
    - get_token:
        do:
          get_authentication:
            - host
            - username
            - password
        publish:
          - response_body: return_result
          - return_code
          - error_message

    - parse_authentication:
        do:
          stackato_utils.parse_authentication:
            - json_authentication_response: response_body
        publish:
          - token
          - error_message
  outputs:
    - token
    - return_result: response_body
    - error_message