#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   DeRegister endpoint is a low level mechanism for directly registering or updating entries in the catalog
#
#   Inputs:
#       - host - consul agent host
#       - consul_port - optional - consul agent host port defualt 8500
#       - node - node name
#       - address - node host
#       - datacenter - optional - defaulted to match that of the agent
#       - service - optional - If the Service key is provided, then the service will also be registered
#       - check - optional - If the Check key is provided, then a health check will also be registered
#   Outputs:
#       - errorMessage - returnResult if there was an error
#   Results:
#       - SUCCESS - parsing was successful (returnCode == '0')
#       - FAILURE - otherwise
##################################################################################################################################################

namespace: org.openscore.slang.consul

imports:
  consul: org.openscore.slang.consul
flow:
  name: deregister_endpoint
  inputs:
    - host
    - consul_port:
        default: "'8500'"
        required: false
    - node
    - address
    - datacenter:
        default: "''"
        required: false
    - service:
        default: "''"
        required: false
    - check:
        default: "''"
        required: false
  workflow:
    - parse_register_endpoint_request:
        do:
          consul.parse_register_endpoint_request:
            - node
            - address
            - datacenter
            - service
            - check
        publish:
          - json_request

    - send_register_endpoint_request:
        do:
          consul.send_deregister_endpoint_request:
            - host
            - consul_port
            - json_request
        publish:
          - errorMessage

  outputs:
      - errorMessage
  results:
      - SUCCESS
      - FAILURE