#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: This operation retrieves the authentication Bearer token for Azure
#!
#! @input username: Azure username
#! @input password: Azure password
#! @input client_id: Service Client ID
#! @input authority: optional - the authority URL
#!                   Default: 'https://sts.windows.net/common'
#! @input resource: optional - the resource URL
#!                  Default: 'https://management.azure.com/'
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - user name used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#!
#! @output auth_token: the authorization Bearer token for Azure
#! @output return_code: '0' if success, '-1' otherwise
#! @output exception: an error message in case there was an error while generating the Bearer token
#!
#! @result SUCCESS: Bearer token generated successfully
#! @result FAILURE: There was an error while trying to retrieve Bearer token.
#!!#
####################################################

namespace: io.cloudslang.microsoft_azure.utility


operation:
  name: get_auth_token
  inputs:
    - username
    - password
    - client_id:
        required: false
    - clientId:
        default: ${get("client_id", "")}
        required: false
        private: true
    - authority:
        required: false
        default: 'https://sts.windows.net/common'
    - resource:
        required: false
        default: 'https://management.azure.com/'
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        required: false
        private: true
        sensitive: true

  java_action:
    gav: 'io.cloudslang.content:cs-azure:0.0.2'
    class_name: io.cloudslang.content.azure.actions.GetAuthorizationToken
    method_name: execute

  outputs:
    - auth_token: ${returnResult}
    - return_code: ${returnCode}
    - exception

  results:
      - SUCCESS: ${returnCode == '0'}
      - FAILURE

