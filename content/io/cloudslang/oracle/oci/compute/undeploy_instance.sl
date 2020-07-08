#   (c) Copyright 2020 Micro Focus, L.P.
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
#! @description:  Undeploy's the specified instance. Any attached VNICs and volumes are automatically detached when the
#!               instance terminates. To preserve the boot volume associated with the instance, specify true for
#!               PreserveBootVolume.To delete the boot volume when the instance is deleted, specify false or
#!               do not specify a value for PreserveBootVolume.
#!
#! @input tenancy_ocid: Oracle creates a tenancy for your company, which is a secure and isolated partition where you
#!                      can create, organize, and administer your cloud resources. This is ID of the tenancy.
#! @input user_ocid: ID of an individual employee or system that needs to manage or use your company’s Oracle Cloud
#!                   Infrastructure resources.
#! @input finger_print: Finger print of the public key generated for OCI account.
#! @input private_key_data: A string representing the private key for the OCI. This string is usually the content of a
#!                          private key file.
#!                          Optional
#! @input private_key_file: The path to the private key file on the machine where is the worker.
#!                        Optional
#! @input api_version: Version of the API of OCI.
#!                     Default: '20160918'
#!                     Optional
#! @input region: The region's name.
#! @input instance_id: The OCID of the instance.
#! @input preserve_boot_volume: Specifies whether to delete or preserve the boot volume when terminating an
#!                              instance.
#!                              Default: 'false'
#!                              Optional
#! @input proxy_host: Proxy server used to access the OCI.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the OCI.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input retry_count: Number of checks if the instance was created successfully.
#!                     Default: '30'
#!                     Optional
#!
#! @output return_result: If successful, returns the success message. In case of an error this output will contain
#!                        the error message.
#!
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################

namespace: io.cloudslang.oracle.oci.compute
flow:
  name: undeploy_instance
  inputs:
    - tenancy_ocid
    - user_ocid
    - finger_print:
        sensitive: true
    - private_key_data:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - api_version:
        required: false
    - region
    - instance_id:
        required: true
    - preserve_boot_volume:
        default: 'false'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - retry_count:
        default: '30'
        required: false
  workflow:
    - terminate_instance:
        do:
          io.cloudslang.oracle.oci.compute.instances.terminate_instance:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_data:
                value: '${private_key_data}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - instance_id: '${instance_id}'
            - preserve_boot_volume: '${preserve_boot_volume}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - return_result
          - status_code
        navigate:
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
    - get_instance_details:
        do:
          io.cloudslang.oracle.oci.compute.instances.get_instance_details:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_data:
                value: '${private_key_data}'
                sensitive: true
            - private_key_file:
                value: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - instance_id: '${instance_id}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - proxy_port: '${proxy_port}'
        publish:
          - instance_state
        navigate:
          - SUCCESS: is_instance_terminated
          - FAILURE: on_failure
    - is_instance_terminated:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: TERMINATED
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: wait_for_instance_to_terminate
    - counter:
        do:
          io.cloudslang.oracle.oci.utils.counter:
            - from: '1'
            - to: '${retry_count}'
            - increment_by: '1'
        navigate:
          - HAS_MORE: get_instance_details
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_instance_to_terminate:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
  results:
    - FAILURE
    - SUCCESS
