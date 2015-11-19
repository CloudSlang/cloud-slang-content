#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Check the disk space percentage on a Linux machine.
#
# Inputs:
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username  - Docker machine username
#   - mount - optional - mount to check disk space for - Default: '/'
#   - password - optional - Docker machine password
#   - privateKeyFile - optional - path to private key file
#   - arguments - optional - arguments to pass to the command
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - - optional - time in milliseconds to wait for command to complete
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false
# Outputs:
#   - disk_space - percentage - Example: 50%
#   - error_message - error message if error occurred
# Results:
#   - SUCCESS - operation finished successfully
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.base.os.linux

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: check_linux_disk_space
  inputs:
    - host
    - port:
        required: false
    - username
    - mount:
        required: false
        default: "/"
    - password:
        required: false
    - privateKeyFile:
        required: false
    - command:
        default: ${ df -kh " + mount + " | grep -v 'Filesystem' | awk '{print $5}' }
        overridable: false
    - arguments:
        required: false
    - characterSet:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - closeSession:
        required: false
  workflow:
    - check_linux_disk_space:
        do:
          ssh.ssh_flow:
            - host
            - port
            - username
            - password
            - privateKeyFile
            - command
            - arguments
            - characterSet
            - pty
            - timeout
            - closeSession
        publish:
          - standard_out
          - standard_err
          - return_code
          - returnResult
  outputs:
    - disk_space: ${ '' if 'standard_out' not in locals() else standard_out.strip() }
    - error_message: ${ '' if 'standard_err' not in locals() else standard_err if return_code == '0' else returnResult }
  results:
    - SUCCESS
    - FAILURE