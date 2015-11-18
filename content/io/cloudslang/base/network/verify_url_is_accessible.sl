#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Checks if a url is accessible.
#
# Inputs:
#   - url - the url
#   - attempts - attempts to reach host
#   - time_to_sleep - time in seconds to wait between attempts
# Outputs:
#   - output_message - timeout exceeded and url was not accessible
# Results:
#   - SUCCESS - url is accessible
#   - FAILURE - url is not accessible
####################################################

namespace: io.cloudslang.base.network

imports:
  math: io.cloudslang.base.math
  rest: io.cloudslang.base.network.rest
  utils: io.cloudslang.base.utils
flow:
  name: verify_url_is_accessible
  inputs:
    - url
    - attempts: 1
    - time_to_sleep:
        default: 1
        required: false
    - content_type:
        default: "'application/json'"
  workflow:

    - http_get:
        do:
          rest.http_client_get:
            - url
            - content_type
            - connect_timeout: "'20'"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: check_if_timed_out

    - check_if_timed_out:
         do:
            math.comparisons.compare_numbers:
              - value1: attempts
              - value2: 0
         navigate:
           GREATER_THAN: wait
           EQUALS: FAILURE
           LESS_THAN: FAILURE

    - wait:
        do:
          utils.sleep:
              - seconds: time_to_sleep
        publish:
          - attempts: self['attempts'] - 1
        navigate:
          SUCCESS: http_get

  outputs:
    - output_message: "'Url is not accessible'"
