#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
# This flow checks whether a droplet is considered zombie.
#
# Inputs:
#   - droplet_name - name of the droplet
#   - creation_time_as_string - creation time (UTC timezone) of the droplet as a string value
#                             - format (used by DigitalOcean): 2015-09-27T18:47:19Z
#   - time_to_live - threshold to compare the droplet's lifetime to (in minutes)
#   - name_pattern - regex pattern for zombie droplet names - e.g. ci-([0-9]+)-coreos-([0-9]+)
#
# Results:
#   - ZOMBIE: droplet is considered zombie
#   - NOT_ZOMBIE: droplet is not considered zombie
#   - FAILURE: error occurred
########################################################################################################
namespace: io.cloudslang.cloud_provider.digital_ocean.v2.examples

imports:
  utils: io.cloudslang.cloud_provider.digital_ocean.v2.utils
  strings: io.cloudslang.base.strings

flow:
  name: check_droplet_is_zombie

  inputs:
    - droplet_name
    - creation_time_as_string
    - time_to_live
    - name_pattern

  workflow:
    - check_droplet_name:
        do:
          strings.match_regex:
            - text: ${droplet_name}
            - regex: ${name_pattern}
        navigate:
          MATCH: check_droplet_lifetime
          NO_MATCH: NOT_ZOMBIE

    - check_droplet_lifetime:
        do:
          utils.check_droplet_lifetime:
            - creation_time_as_string
            - threshold: ${time_to_live}
        navigate:
          FAILURE: FAILURE
          ABOVE_THRESHOLD: ZOMBIE
          BELOW_THRESHOLD: NOT_ZOMBIE
  results:
    - ZOMBIE
    - NOT_ZOMBIE
    - FAILURE
