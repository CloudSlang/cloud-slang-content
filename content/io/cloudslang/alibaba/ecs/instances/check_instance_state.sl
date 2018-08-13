#   (c) Copyright 2018 Micro Focus
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: The operation checks if an instance has a specific state.
#!
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS account.
#! @input access_key_secret: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Proxy server used to access the provider services
#! @input proxy_port: Proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Optional - Proxy server user name.
#!                        Default: ''
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username
#!                        input value.
#!                        Default: ''
#! @input instance_id: The ID of the server (instance) you want to check.
#! @input region_id: Region ID of an instance. You can call DescribeRegions to obtain the latest region list.
#! @input instance_status: The state that you would like the instance to have.
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '10'
#!
#! @output output: Contains the success message or the exception in case of failure
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The server (instance) has the expected state
#! @result FAILURE: Error checking the instance state, or the actual state is not the expected one
#!!#
########################################################################################################################

namespace: io.cloudslang.alibaba.ecs.instances

imports:
  instances: io.cloudslang.alibaba.ecs.instances
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: check_instance_state

  inputs:
    - access_key_id
    - access_key_secret:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - instance_id
    - region_id
    - instance_status
    - polling_interval:
        required: false

  workflow:
    - describe_instances:
        do:
          instances.get_instance_status_:
            - access_key_id
            - access_key_secret
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - region_id
            - instance_id: ${instance_id}
        publish:
          - return_result
          - return_code
          - exception
          - instance_status_returned: '${instance_status}'
        navigate:
          - SUCCESS: string_occurrence_counter
          - FAILURE: on_failure

    - string_occurrence_counter:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${instance_status_returned}
            - string_to_find: ${instance_status}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: sleep

    - sleep:
        do:
          utils.sleep:
            - seconds: ${get('polling_interval', '10')}
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure

  outputs:
    - output: ${return_result}
    - return_code
    - exception

  results:
    - SUCCESS
    - FAILURE
