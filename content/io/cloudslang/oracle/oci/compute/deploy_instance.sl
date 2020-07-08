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
#! @description: Deploy's a new instance in the specified compartment and the specified availability domain.
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
#! @input availability_domain: The availability domain of the instance.
#! @input subnet_id: The OCID of the subnet to create the VNIC in.
#! @input shape: The shape of an instance. The shape determines the number of CPUs, amount of memory, and other
#!               resources allocated to the instance.
#! @input region: The region's name.
#! @input api_version: Version of the API of OCI.
#!                     Default: '20160918'
#!                     Optional
#! @input display_name: A user-friendly name. Does not have to be unique, and it's changeable.Ex: My bare metal instance
#!                      Optional
#! @input hostname_label: The hostname for the VNIC's primary private IP. Used for DNS. The value is the hostname
#!                        portion of the primary private IP's fully qualified domain name.
#!                        Optional
#! @input defined_tags: Defined tags for this resource. Each key is predefined and scoped to a namespace.
#!                      Ex: {"Operations": {"CostCenter": "42"}}
#!                      Optional
#! @input freeform_tags: Free-form tags for this resource. Each tag is a simple key-value pair with no predefined name,
#!                       type, or namespace.
#!                       Ex: {"Department": "Finance"}
#!                       Optional
#! @input ssh_authorized_keys: Provide one or more public SSH keys  for the default user on the instance. Use a newline
#!                             character to separate multiple keys.
#!                             Optional
#! @input userdata: Provide your own base64-encoded data to be used by Cloud-Init to run custom scripts or provide
#!                  custom Cloud-Init configuration.
#!                  Optional
#! @input dedicated_vm_host_id: The OCID of the dedicated VM host.
#!                              Optional
#! @input extended_metadata: Additional metadata key/value pairs that you provide. They serve the same purpose and
#!                           functionality as fields in the 'metadata' object.
#!                           They are distinguished from 'metadata'
#!                           fields in that these can be nested JSON objects (whereas 'metadata' fields are
#!                           string/string maps only).
#!                           Optional
#! @input fault_domain: A fault domain is a grouping of hardware and infrastructure within an availability domain. Each
#!                      availability domain contains three fault domains. Fault domains let you distribute your
#!                      instances so that they are not on the same physical hardware within a single availability
#!                      domain. A hardware failure or Compute hardware maintenance that affects one fault domain does
#!                      not affect instances in other fault domains.
#!                      If you do not specify the fault domain, the system
#!                      selects one for you.
#!                      Optional
#! @input source_type: The source type for the instance. Use image when specifying the image OCID. Use bootVolume when
#!                     specifying the boot volume OCID.
#! @input image_id: The OCID of the image used to boot the instance. If the sourceType is 'image', then this value is
#!                  required.
#!                  Optional
#! @input boot_volume_size_in_gbs: The size of the boot volume in GBs. Minimum value is 50 GB and maximum value is
#!                                 16384 GB (16TB).
#!                                 Optional
#! @input kms_key_id: The OCID of the Key Management key to assign as the master encryption key for the boot volume.
#!                    Optional
#! @input boot_volume_id: The OCID of the boot volume used to boot the instance. If the sourceType is 'bootVolume', then
#!                        this value is required.
#!                        Optional
#! @input vnic_display_name: A user-friendly name for the VNIC. Does not have to be unique.
#!                           Optional
#! @input assign_public_ip: Whether the VNIC should be assigned a public IP address. Defaults to whether the subnet is
#!                          public or private.
#!                          Optional
#! @input vnic_defined_tags: Defined tags for VNIC. Each key is predefined and scoped to a namespace.
#!                           Ex: {"Operations": {"CostCenter": "42"}}
#!                           Optional
#! @input vnic_freeform_tags: Free-form tags for VNIC. Each tag is a simple key-value pair with no predefined name,
#!                            type, or namespace.
#!                            Ex: {"Department": "Finance"}
#!                            Optional
#! @input network_security_group_ids: A list of the OCIDs of the network security groups (NSGs) to add the VNIC to.
#!                                    Maximum allowed security groups are 5
#!                                    Ex: [nsg1,nsg2]
#!                                    Optional
#! @input private_ip: A private IP address of your choice to assign to the VNIC. Must be an available IP address within
#!                    the subnet's CIDR. If you don't specify a value, Oracle automatically assigns a private IP address
#!                    from the subnet. This is the VNIC's primary private IP address.
#!                    Optional
#! @input skip_source_dest_check: Whether the source/destination check is disabled on the VNIC.
#!                                Default: 'false'
#!                                Optional
#! @input ocpus: The total number of OCPUs available to the instance.
#!               Optional
#! @input launch_mode: Specifies the configuration mode for launching virtual machine (VM) instances. The configuration
#!                     modes are:
#!                     NATIVE - VM instances launch with iSCSI boot and VFIO devices. The default value for
#!                     Oracle-provided images.
#!                     EMULATED - VM instances launch with emulated devices, such as the E1000
#!                     network driver and emulated SCSI disk controller.
#!                     PARAVIRTUALIZED - VM instances launch with
#!                     paravirtualized devices using virtio drivers.
#!                     CUSTOM - VM instances launch with custom
#!                     configuration settings specified in the LaunchOptions parameter.
#!                     Optional
#! @input is_pv_encryption_in_transit_enabled: Whether to enable in-transit encryption for the data volume's
#!                                             paravirtualized attachment.Default: 'false'
#!                                             Optional
#! @input ipxe_script: When a bare metal or virtual machine instance boots, the iPXE firmware that runs on the instance
#!                     is configured to run an iPXE script to continue the boot process.
#!                     If you want more control over
#!                     the boot process, you can provide your own custom iPXE script that will run when the instance
#!                     boots; however, you should be aware that the same iPXE script will run every time an instance
#!                     boots; not only after the initial LaunchInstance call.
#!                     Optional
#! @input boot_volume_type: Emulation type for volume.
#!                          ISCSI - ISCSI attached block storage device.
#!                          SCSI - Emulated SCSI disk.
#!                          IDE - Emulated IDE disk.
#!                          VFIO - Direct attached Virtual Function storage. This is the
#!                          default option for Local data volumes on Oracle provided images.
#!                          PARAVIRTUALIZED -
#!                          Paravirtualized disk. This is the default for Boot Volumes and Remote Block Storage volumes
#!                          on Oracle provided images.
#!                          Optional
#! @input firmware: Firmware used to boot VM. Select the option that matches your operating system.
#!                  BIOS - Boot VM using
#!                  BIOS style firmware. This is compatible with both 32 bit and 64 bit operating systems that boot
#!                  using MBR style bootloaders.
#!                  UEFI_64 - Boot VM using UEFI style firmware compatible with 64 bit
#!                  operating systems. This is the default for Oracle provided images.
#!                  Optional
#! @input is_consistent_volume_naming_enabled: Whether to enable consistent volume naming feature.
#!                                             Default: 'false'
#!                                             Optional
#! @input network_type: Emulation type for the physical network interface card (NIC).
#!                      E1000 - Emulated Gigabit ethernet
#!                      controller. Compatible with Linux e1000 network driver.
#!                      VFIO - Direct attached Virtual Function
#!                      network controller. This is the networking type when you launch an instance using
#!                      hardware-assisted (SR-IOV) networking.
#!                      PARAVIRTUALIZED - VM instances launch with
#!                      paravirtualized devices using virtio drivers.
#!                      Optional
#! @input remote_data_volume_type: Emulation type for volume.
#!                                 ISCSI - ISCSI attached block storage device.
#!                                 SCSI -
#!                                 Emulated SCSI disk.
#!                                 IDE - Emulated IDE disk.
#!                                 VFIO - Direct attached Virtual Function
#!                                 storage. This is the default option for Local data volumes on Oracle provided
#!                                 images.
#!                                 PARAVIRTUALIZED - Paravirtualized disk.This is the default for Boot Volumes
#!                                 and Remote Block Storage volumes on Oracle provided images.
#!                                 Optional
#! @input is_management_disabled: Whether the agent running on the instance can run all the available management
#!                                plugins.
#!                                Default: 'false'
#!                                Optional
#! @input is_monitoring_disabled: Whether the agent running on the instance can gather performance metrics and monitor
#!                                the instance
#!                                Default: 'false'
#!                                Optional
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
#! @input get_default_Credentials: Gets the generated credentials for the instance. Only works for instances that
#!                                 require a password to log in, such as Windows make the value as 'true'.
#!                                 Default: 'false'
#!                                 Optional
#!
#! @output instance_name: The instance name.
#! @output instance_id: The OCID of the instance.
#! @output instance_state: The current state of the instance.
#! @output vnic_name: Name of the VNIC.
#! @output vnic_id: The OCID of the vnic.
#! @output vnic_state: The current state of the VNIC.
#! @output vnic_hostname: The hostname for the VNIC's primary private IP. Used for DNS.
#! @output private_ip_address: The private IP address of the primary privateIp object on the VNIC. The address is within the
#!                     CIDR of the VNIC's subnet.
#! @output public_ip_address: The public IP address of the VNIC.
#! @output mac_address: The MAC address of the VNIC.
#! @output default_username: Default username of the instance.
#! @output default_password: Default password of the instance.
#!
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################

namespace: io.cloudslang.oracle.oci.compute
flow:
  name: deploy_instance
  inputs:
    - tenancy_ocid
    - user_ocid
    - finger_print:
        sensitive: true
    - private_key_data:
        sensitive: true
        required: false
    - private_key_file:
        required: false
    - compartment_ocid
    - availability_domain
    - subnet_id
    - shape
    - region
    - api_version:
        required: false
    - display_name:
        required: false
    - hostname_label:
        required: false
    - defined_tags:
        required: false
    - freeform_tags:
        required: false
    - ssh_authorized_keys:
        required: false
        sensitive: true
    - userdata:
        required: false
    - dedicated_vm_host_id:
        required: false
    - extended_metadata:
        required: false
    - fault_domain:
        required: false
    - source_type:
        required: false
    - image_id:
        required: false
    - boot_volume_size_in_gbs:
        required: false
    - kms_key_id:
        required: false
    - boot_volume_id:
        required: false
    - vnic_display_name:
        required: false
    - assign_public_ip:
        required: false
    - vnic_defined_tags:
        required: false
    - vnic_freeform_tags:
        required: false
    - network_security_group_ids:
        required: false
    - private_ip:
        required: false
    - skip_source_dest_check:
        required: false
    - ocpus:
        required: false
    - launch_mode:
        required: false
    - is_pv_encryption_in_transit_enabled:
        required: false
    - ipxe_script:
        required: false
    - boot_volume_type:
        required: false
    - firmware:
        required: false
    - is_consistent_volume_naming_enabled:
        required: false
    - network_type:
        required: false
    - remote_data_volume_type:
        required: false
    - is_management_disabled:
        required: false
    - is_monitoring_disabled:
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
    - get_default_Credentials:
        default: 'false'
        required: false
  workflow:
    - create_instance:
        do:
          io.cloudslang.oracle.oci.compute.instances.create_instance:
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
            - compartment_ocid: '${compartment_ocid}'
            - region: '${region}'
            - availability_domain: '${availability_domain}'
            - shape: '${shape}'
            - subnet_id: '${subnet_id}'
            - source_type: '${source_type}'
            - boot_volume_size_in_gbs: '${boot_volume_size_in_gbs}'
            - kms_key_id: '${kms_key_id}'
            - boot_volume_id: '${boot_volume_id}'
            - dedicated_vm_host_id: '${dedicated_vm_host_id}'
            - image_id: '${image_id}'
            - defined_tags: '${defined_tags}'
            - freeform_tags: '${freeform_tags}'
            - display_name: '${display_name}'
            - userdata: '${userdata}'
            - extended_metadata: '${extended_metadata}'
            - launch_mode: '${launch_mode}'
            - fault_domain: '${fault_domain}'
            - is_pv_encryption_in_transit_enabled: '${is_pv_encryption_in_transit_enabled}'
            - ipxe_script: '${ipxe_script}'
            - vnic_display_name: '${vnic_display_name}'
            - ssh_authorized_keys:
                value: '${ssh_authorized_keys}'
                sensitive: true
            - assign_public_ip: '${assign_public_ip}'
            - vnic_defined_tags: '${vnic_defined_tags}'
            - vnic_freeform_tags: '${vnic_freeform_tags}'
            - network_security_group_ids: '${network_security_group_ids}'
            - private_ip: '${private_ip}'
            - skip_source_dest_check: '${skip_source_dest_check}'
            - ocpus: '${ocpus}'
            - boot_volume_type: '${boot_volume_type}'
            - firmware: '${firmware}'
            - is_consistent_volume_naming_enabled: '${is_consistent_volume_naming_enabled}'
            - network_type: '${network_type}'
            - remote_data_volume_type: '${remote_data_volume_type}'
            - is_management_disabled: '${is_management_disabled}'
            - is_monitoring_disabled: '${is_monitoring_disabled}'
            - hostname_label: '${hostname_label}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - proxy_port: '${proxy_port}'
        publish:
          - return_result
          - instance_id
          - instance_name
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
          - SUCCESS: instance_status
          - FAILURE: on_failure
    - instance_status:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: RUNNING
        navigate:
          - SUCCESS: list_vnic_attachments
          - FAILURE: wait_for_instance_status
    - get_vnic_details:
        do:
          io.cloudslang.oracle.oci.compute.vnics.get_vnic_details:
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
            - vnic_id: '${vnic_id}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - proxy_port: '${proxy_port}'
        publish:
          - private_ip
          - public_ip
          - vnic_name
          - vnic_hostname
          - vnic_state
          - mac_address
        navigate:
          - SUCCESS: get_default_credentials
          - FAILURE: FAILURE
    - list_vnic_attachments:
        do:
          io.cloudslang.oracle.oci.compute.vnics.list_vnic_attachments:
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
            - compartment_ocid: '${compartment_ocid}'
            - region: '${region}'
            - instance_id: '${instance_id}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - proxy_port: '${proxy_port}'
        publish:
          - vnic_id: '${vnic_list}'
        navigate:
          - SUCCESS: get_vnic_details
          - FAILURE: on_failure
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
    - wait_for_instance_status:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
    - get_default_credentials:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${get_default_Credentials}'
            - second_string: 'true'
        publish:
          - default_username: ''
          - default_password: ''
        navigate:
          - SUCCESS: get_instance_default_credentials
          - FAILURE: SUCCESS
    - get_instance_default_credentials:
        do:
          io.cloudslang.oracle.oci.compute.instances.get_instance_default_credentials:
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
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - default_username: '${instance_username}'
          - default_password: '${instance_password}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  outputs:
    - instance_name: '${instance_name}'
    - instance_id: '${instance_id}'
    - instance_state: '${instance_state}'
    - vnic_name: '${vnic_name}'
    - vnic_id: '${vnic_id}'
    - vnic_state: '${vnic_state}'
    - vnic_hostname: '${vnic_hostname}'
    - private_ip_address: '${private_ip}'
    - public_ip_address: '${public_ip}'
    - mac_address: '${mac_address}'
    - default_username: '${default_username}'
    - default_password: '${default_password}'
  results:
    - FAILURE
    - SUCCESS
