#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs a search in the response_headers to get the specified header value.
#!
#! @input response_headers: response headers string from an HTTP Client REST call
#! @input header_name: name of header to get value for
#!
#! @output result: specified header value in case of success, error message otherwise
#! @output error_message: exception if occurs
#!
#! @result SUCCESS: retrieved specified header value
#! @result FAILURE: there was an error retrieving header value
#!!#
########################################################################################################################

namespace: io.cloudslang.base.http

operation:
  name: get_header_value

  inputs:
    - response_headers
    - header_name

  python_action:
    script: |
      result = ''
      error_message = ''
      try:
        begin_index = response_headers.find(header_name + ':')
        if begin_index != -1:
          response_headers = response_headers[begin_index + len(header_name) + 2:]
          result = response_headers.split(' ')[0]
        else:
          error_message = 'Could not find specified header: ' + header_name
          result = error_message
      except Exception as exception:
        error_message = exception

  outputs:
    - result
    - error_message

  results:
    - SUCCESS: ${error_message == ''}
    - FAILURE
