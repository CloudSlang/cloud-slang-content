#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.cloud_provider.google.gke

imports:
  utils: io.cloudslang.base.utils
  print: io.cloudslang.base.print

flow:
  name: test_list
  inputs:
    - projectId
    - zone
    - jSonGoogleAuthPath
    - name
    - initialNodeCount
    - network
    - operationId
  workflow:
    - ListClusters:
        do:
          list_clusters:
            - projectId
            - jSonGoogleAuthPath
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_ListClusters:
        do:
          print.print_text:
            - text: response

    - ListOperations:
        do:
          list_operations:
            - projectId
            - jSonGoogleAuthPath
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_ListOperations:
        do:
          print.print_text:
            - text: response

    - getServerconfig:
        do:
          get_serverconfig:
            - projectId
            - jSonGoogleAuthPath
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_getServerconfig:
        do:
          print.print_text:
            - text: response

    - getOperation:
        do:
          get_operations:
            - projectId
            - zone
            - jSonGoogleAuthPath
            - operationId
        publish:
          - return_result
          - response
          - error_message
          - response_body: return_result

    - print_getOperations:
        do:
          print.print_text:
            - text: response
  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS
    - FAILURE

