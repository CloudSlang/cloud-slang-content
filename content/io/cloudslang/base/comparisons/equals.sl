#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Compares two inputs for Python equality (==).
#
# Inputs:
#   - first - first object to compare
#   - second - second object to compare
# Results:
#   - EQUAL - object are equal
#   - NOT_EQUAL - objects are not equal
####################################################

namespace: io.cloudslang.base.comparisons

operation:
  name: equals
  inputs:
    - first
    - second
  action:
    python_script: |
      eq = first == second
  results:
    - EQUALS: ${ eq }
    - NOT_EQUALS