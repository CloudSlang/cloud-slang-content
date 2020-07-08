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
#! @description: Lists the VNIC attachments in the specified compartment. A VNIC attachment resides in the same
#!               compartment as the attached instance.The list can be filtered by instance, VNIC, or availability
#!               domain.
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
#! @input compartment_ocid: Compartments are a fundamental component of Oracle Cloud Infrastructure for organizing and
#!                          isolating your cloud resources. This is ID of the compartment.
#! @input api_version: Version of the API of OCI.
#!                     Default: '20160918'
#!                     Optional
#! @input region: The region's name.
#! @input availability_domain: The availability domain of the instance.
#! @input instance_id: The OCID of the instance.
#!                     Optional
#! @input vnic_id: The OCID of the vnic.
#!                 Optional
#! @input limit: For list pagination. The maximum number of results per page, or items to return in a paginated "List"
#!               call. 
#!               Optional
#! @input page: For list pagination. The value of the opc-next-page response header from the previous "List" call.
#!              Optional
#! @input proxy_host: Proxy server used to access the OCI.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the OCI.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output exception: An error message in case there was an error while executing the request.
#! @output vnic_list: List of Vnics OCIDs.
#! @output status_code: The HTTP status code for OCI API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.oracle.oci.compute.vnics

operation: 
  name: list_vnic_attachments
  
  inputs: 
    - tenancy_ocid    
    - tenancyOcid: 
        default: ${get('tenancy_ocid', '')}
        private: true 
    - user_ocid    
    - userOcid: 
        default: ${get('user_ocid', '')}
        private: true 
    - finger_print:    
        sensitive: true
    - fingerPrint: 
        default: ${get('finger_print', '')}
        private: true 
        sensitive: true
    - private_key_data:
        required: false
        sensitive: true
    - privateKeyData:
        default: ${get('private_key_data', '')}
        required: false
        private: true
        sensitive: true
    - private_key_file:
        required: false
    - privateKeyFile:
        default: ${get('private_key_file', '')}
        required: false
        private: true
    - compartment_ocid    
    - compartmentOcid: 
        default: ${get('compartment_ocid', '')}
        private: true 
    - api_version:  
        required: false  
    - apiVersion: 
        default: ${get('api_version', '')}  
        required: false 
        private: true 
    - region    
    - availability_domain:
        required: false
    - availabilityDomain: 
        default: ${get('availability_domain', '')}  
        required: false 
        private: true 
    - instance_id:  
        required: false  
    - instanceId: 
        default: ${get('instance_id', '')}  
        required: false 
        private: true 
    - vnic_id:  
        required: false  
    - vnicId: 
        default: ${get('vnic_id', '')}  
        required: false 
        private: true 
    - limit:  
        required: false  
    - page:  
        required: false  
    - proxy_host:  
        required: false  
    - proxyHost: 
        default: ${get('proxy_host', '')}  
        required: false 
        private: true 
    - proxy_port:  
        required: false  
    - proxyPort: 
        default: ${get('proxy_port', '')}  
        required: false 
        private: true 
    - proxy_username:  
        required: false  
    - proxyUsername: 
        default: ${get('proxy_username', '')}  
        required: false 
        private: true 
    - proxy_password:  
        required: false  
        sensitive: true
    - proxyPassword: 
        default: ${get('proxy_password', '')}  
        required: false 
        private: true 
        sensitive: true

    
  java_action: 
    gav: 'io.cloudslang.content:cs-oracle-cloud:1.0.0-RC17'
    class_name: 'io.cloudslang.content.oracle.oci.actions.vnics.ListVnicAttachments'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - exception: ${get('exception', '')} 
    - vnic_list: ${get('vnic_list', '')} 
    - status_code: ${get('statusCode', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE