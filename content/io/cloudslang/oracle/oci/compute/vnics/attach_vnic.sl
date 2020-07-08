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
#! @description: Creates a secondary VNIC and attaches it to the specified instance.
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
#!                          Optional
#! @input api_version: Version of the API of OCI.
#!                     Default: '20160918'
#!                     Optional
#! @input region: The region's name.
#! @input instance_id: The OCID of the instance.
#! @input subnet_id: The OCID of the subnet to create the VNIC in.
#! @input assign_public_ip: Whether the VNIC should be assigned a public IP address. Defaults to whether the subnet is
#!                          public or private.
#!                          Optional
#! @input vnic_display_name: A user-friendly name for the VNIC. Does not have to be unique.
#!                           Optional
#! @input hostname_label: The hostname for the VNIC's primary private IP. Used for DNS. The value is the hostname
#!                        portion of the primary private IP's fully qualified domain name.
#!                        Optional
#! @input vnic_defined_tags: Defined tags for VNIC. Each key is predefined and scoped to a namespace.Ex: {"Operations":
#!                           {"CostCenter": "42"}}
#!                           Optional
#! @input vnic_freeform_tags: Free-form tags for VNIC. Each tag is a simple key-value pair with no predefined name,
#!                            type, or namespace.Ex: {"Department": "Finance"}
#!                            Optional
#! @input network_security_group_ids: A list of the OCIDs of the network security groups (NSGs) to add the VNIC to.
#!                                    Maximum allowed security groups are 5Ex: [nsg1,nsg2]
#!                                    Optional
#! @input private_ip: A private IP address of your choice to assign to the VNIC. Must be an available IP address within
#!                    the subnet's CIDR. If you don't specify a value, Oracle automatically assigns a private IP address
#!                    from the subnet. This is the VNIC's primary private IP address.
#!                    Optional
#! @input skip_source_dest_check: Whether the source/destination check is disabled on the VNIC.
#!                                Default: 'false'
#!                                Optional
#! @input vnic_attachment_display_name: A user-friendly name for the attachment. Does not have to be unique, and it
#!                                      cannot be changed.
#!                                      Optional
#! @input nic_index: Which physical network interface card (NIC) the VNIC will use. Defaults to 0. Certain bare metal
#!                   instance shapes have two active physical NICs (0 and 1). If you add a secondary VNIC to one of
#!                   these instances, you can specify which NIC the VNIC will use.
#!                   Optional
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
#! @output vnic_attachment_state: Life cycle state of the vnic attachment.
#! @output vnic_attachment_id: The OCID of the vnic attachment.
#! @output exception: An error message in case there was an error while executing the request.
#! @output status_code: The HTTP status code for OCI API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.oracle.oci.compute.vnics

operation: 
  name: attach_vnic
  
  inputs: 
    - tenancy_ocid    
    - tenancyOcid: 
        default: ${get('tenancy_ocid', '')}  
        required: false 
        private: true 
    - user_ocid    
    - userOcid: 
        default: ${get('user_ocid', '')}  
        required: false 
        private: true 
    - finger_print:    
        sensitive: true
    - fingerPrint: 
        default: ${get('finger_print', '')}  
        required: false 
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
    - api_version:  
        required: false  
    - apiVersion: 
        default: ${get('api_version', '')}  
        required: false 
        private: true 
    - region    
    - instance_id    
    - subnet_id    
    - subnetId: 
        default: ${get('subnet_id', '')}  
        required: false 
        private: true 
    - assign_public_ip:  
        required: false  
    - assignPublicIP: 
        default: ${get('assign_public_ip', '')}  
        required: false 
        private: true 
    - vnic_display_name:  
        required: false  
    - vnicDisplayName: 
        default: ${get('vnic_display_name', '')}  
        required: false 
        private: true 
    - hostname_label:  
        required: false  
    - hostnameLabel: 
        default: ${get('hostname_label', '')}  
        required: false 
        private: true 
    - vnic_defined_tags:  
        required: false  
    - vnicDefinedTags: 
        default: ${get('vnic_defined_tags', '')}  
        required: false 
        private: true 
    - vnic_freeform_tags:  
        required: false  
    - vnicFreeformTags: 
        default: ${get('vnic_freeform_tags', '')}  
        required: false 
        private: true 
    - network_security_group_ids:  
        required: false  
    - networkSecurityGroupIds: 
        default: ${get('network_security_group_ids', '')}  
        required: false 
        private: true 
    - private_ip:  
        required: false  
    - privateIP: 
        default: ${get('private_ip', '')}  
        required: false 
        private: true 
    - skip_source_dest_check:  
        required: false  
    - skipSourceDestCheck: 
        default: ${get('skip_source_dest_check', '')}  
        required: false 
        private: true 
    - vnic_attachment_display_name:
        required: false
    - vnicAttachmentDisplayName: 
        default: ${get('vnic_attachment_display_name', '')}  
        required: false 
        private: true 
    - nic_index:  
        required: false  
    - nicIndex: 
        default: ${get('nic_index', '')}  
        required: false 
        private: true 
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
    class_name: 'io.cloudslang.content.oracle.oci.actions.vnics.AttachVnic'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - vnic_attachment_state: ${get('vnicAttachmentState', '')}
    - vnic_attachment_id: ${get('vnicAttachmentId', '')}
    - exception: ${get('exception', '')} 
    - status_code: ${get('statusCode', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
