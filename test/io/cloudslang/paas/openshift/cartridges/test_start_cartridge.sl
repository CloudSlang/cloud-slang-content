#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.paas.openshift.cartridges

imports:
  lists: io.cloudslang.base.lists
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings

flow:
  name: test_start_cartridge
  inputs:
    - host
    - username:
        default: "''"
        required: false
    - password:
        default: "''"
        required: false
    - proxy_host:
        default: "''"
        required: false
    - proxy_port:
        default: "'8080'"
        required: false
    - proxy_username:
        default: "''"
        required: false
    - proxy_password:
        default: "''"
        required: false
    - domain
    - application_name
    - cartridge

  workflow:
    - start_cartridge:
        do:
          start_cartridge:
            - host
            - username
            - password
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - domain
            - application_name
            - cartridge
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          SUCCESS: check_result
          FAILURE: START_CARTRIDGE_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: [str(error_message), int(return_code), int(status_code)]
            - list_2: ["''", 0, 200]
        navigate:
          SUCCESS: get_status
          FAILURE: CHECK_RESPONSES_FAILURE

    - get_status:
        do:
          json.get_value_from_json:
            - json_input: return_result
            - key_list: ["'status'"]
        publish:
          - status: value
        navigate:
          SUCCESS: verify_status
          FAILURE: GET_STATUS_FAILURE

    - verify_status:
        do:
          strings.string_equals:
            - first_string: "'ok'"
            - second_string: str(status)
        navigate:
          SUCCESS: get_text_messages
          FAILURE: VERIFY_STATUS_FAILURE

    - get_text_messages:
        do:
          json.get_value_from_json:
            - json_input: return_result
            - key_list: ["'messages'", 0, "'text'"]
        publish:
          - messages: value
        navigate:
          SUCCESS: get_text_occurrence
          FAILURE: GET_TEXT_MESSAGES_FAILURE

    - get_text_occurrence:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: str(messages)
            - string_to_find: "'Started ' + cartridge + ' on ' + application_name"
            - ignore_case: True
        publish:
          - text_occurrence: return_result
        navigate:
          SUCCESS: verify_text
          FAILURE: GET_TEXT_OCCURRENCE_FAILURE

    - verify_text:
        do:
          strings.string_equals:
            - first_string: str(text_occurrence)
            - second_string: str(1)
        navigate:
          SUCCESS: SUCCESS
          FAILURE: VERIFY_TEXT_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - START_CARTRIDGE_FAILURE
    - CHECK_RESPONSES_FAILURE
    - GET_STATUS_FAILURE
    - VERIFY_STATUS_FAILURE
    - GET_TEXT_MESSAGES_FAILURE
    - GET_TEXT_OCCURRENCE_FAILURE
    - VERIFY_TEXT_FAILURE