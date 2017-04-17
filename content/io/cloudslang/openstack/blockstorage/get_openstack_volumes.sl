#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Performs a REST call to retrieve a list of OpenStack volumes.
#
# Inputs:
#   - host - OpenStack machine host
#   - blockstorage_port - optional - port used for OpenStack computations - Default: 8776
#   - token - OpenStack token obtained after authentication
#   - tenant - OpenStack tenantID obtained after authentication
#   - proxy_host - optional - proxy server used to access the web site - Default: none
#   - proxy_port - optional - proxy server port - Default: none
# Outputs:
#   - return_result - response of the operation
#   - status_code - normal statusCode is 202
#   - error_message - error message
# Results:
#   - SUCCESS - operation succeeded (statusCode == '200')
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.openstack.blockstorage

operation:
  name: get_openstack_volumes
  inputs:
    - host
    - blockstorage_port:
        default: "'8776'"
    - token
    - tenant
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxyHost: "proxy_host if proxy_host else ''"
    - proxyPort: "proxy_port if proxy_port else ''"
    - headers:
        default: "'X-AUTH-TOKEN:' + token"
        overridable: false
    - url:
        default: "'http://'+ host + ':' + blockstorage_port + '/v2/' + tenant + '/volumes'"
        overridable: false
    - method:
        default: "'get'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - status_code: statusCode
    - error_message: returnResult if statusCode != '202' else ''
  results:
    - SUCCESS : "'statusCode' in locals() and statusCode == '200'"
    - FAILURE