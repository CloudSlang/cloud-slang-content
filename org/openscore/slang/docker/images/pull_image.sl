#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will pull a docker image.
#
#   Inputs:
#       - imageName - image name to be pulled
#       - host - Docker machine host
#       - port - optional - SSH port - Default: 22
#       - username - Docker machine username
#       - password - Docker machine password
#   Outputs:
#       - returnResult - response of the operation
#       - errorMessage - error message
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################

namespace: org.openscore.slang.docker.images

operations:

 - pull_image:
    inputs:
        - imageName
        - host
        - port:
            default: "'22'"
            required: false
        - username
        - password
        - privateKeyFile:
            default: "''"
            override: true
        - command:
            default: "'docker pull ' + imageName"
            override: true
        - arguments:
            default: "''"
            override: true
        - characterSet:
            default: "'UTF-8'"
            override: true
        - pty:
            default: "'false'"
            override: true
        - timeout:
            default: "'30000000'"
            override: true
        - closeSession:
            default: "'false'"
            override: true
    action:
        java_action:
          className: org.openscore.content.ssh.actions.SSHShellCommandAction
          methodName: runSshShellCommand
    outputs:
        - returnResult: returnResult
        - errorMessage: STDERR if returnCode == '0' else returnResult
    results:
        - SUCCESS : returnCode == '0' and (not 'Error' in STDERR)
        - FAILURE