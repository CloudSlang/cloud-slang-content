#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
###############################################################################################################################################################################
#  Runs an SSH command on the host.
#
#  Inputs:
#    - host - hostname or IP address
#    - port - optional - port number for running the command
#    - command - command to execute
#    - pty - optional - whether to use pty - Valid: true, false - Default: false
#    - username - username to connect as
#    - password - password of user
#    - arguments - optional - arguments to pass to the command
#    - privateKeyFile - optional - the absolute path to the private key file
#    - timeout - optional - time in milliseconds to wait for the command to complete - Default: 90000 ms
#    - characterSet - optional - character encoding used for input stream encoding from the target machine - Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#    - closeSession - optional - if false the ssh session will be cached for future calls of this operation during the life of the flow, if true the ssh session used by this operation will be closed - Valid: true, false - Default: true
# Outputs:
#    - returnResult - STDOUT of the remote machine in case of success or the cause of the error in case of exception
#    - STDOUT - STDOUT of the machine in case of successful request, null otherwise
#    - STDERR - STDERR of the machine in case of successful request, null otherwise
#    - exception - contains the stack trace in case of an exception
# Results:
#    - SUCCESS - SSH access was successful and returned with code 0
#    - FAILURE - otherwise
###############################################################################################################################################################################

namespace: org.openscore.slang.base.remote_command_execution.ssh

operation:
    name: ssh_command
    inputs:
      - host
      - port:
            required: false
      - command
      - pty:
            default: "'false'"
      - username
      - password
      - arguments:
            required: false
      - privateKeyFile:
            required: false
      - timeout:
            default: "'90000'"
      - characterSet:
            default: "'UTF-8'"
      - closeSession:
            default: "'true'"
    action:
      java_action:
        className: org.openscore.content.ssh.actions.SSHShellCommandAction
        methodName: runSshShellCommand
    outputs:
      - returnResult
      - STDOUT
      - STDERR
      - exception
    results:
      - SUCCESS: returnCode == '0'
      - FAILURE