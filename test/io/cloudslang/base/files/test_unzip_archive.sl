# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Workflow to test unzip operation.
#
# Inputs:
#   - path - path to the archive
#   - out_folder - path of folder to place unzipped files from archive
# Results:
#   - SUCCESS - archive unziped successfully
#   - ZIPFAILURE - ziping archive failed
#   - UNZIPFAILURE - unziping operation failed
#   - DELETEFAILURE - deleting archive failed
#
####################################################
namespace: io.cloudslang.base.files

imports:
  files: io.cloudslang.base.files
  utils: io.cloudslang.base.utils
flow:
  name: test_unzip_archive
  inputs:
    - path
    - out_folder
  workflow:
    - zip_folder:
        do:
          files.zip_folder:
            - archive_name: path.split('.')[0]
            - folder_path: "'test'"
        navigate:
          SUCCESS: unzip_folder
          FAILURE: ZIPFAILURE
    - unzip_folder:
        do:
          files.unzip_archive:
            - archive_path:
                default: "'./test/' + path"
                overridable: false
            - output_folder: out_folder
        navigate:
          SUCCESS: delete_output_folder
          FAILURE: UNZIPFAILURE
    - delete_output_folder:
        do:
          files.delete:
            - source:
                default: out_folder
                overridable: false
        navigate:
          SUCCESS: delete_archive
          FAILURE: DELETEFAILURE

    - delete_archive:
        do:
          files.delete:
            - source:
                default: "'./test/' + path"
                overridable: false
        navigate:
          SUCCESS: SUCCESS
          FAILURE: DELETEFAILURE

  results:
    - SUCCESS
    - ZIPFAILURE
    - UNZIPFAILURE
    - DELETEFAILURE
