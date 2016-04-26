namespace: io.cloudslang.base.datetime

operation:
  name: get_time
  inputs:
    - localeLang
    - localeCountry
  action:
    java_action:
      className: io.cloudslang.content.datetime.actions.GetCurrentDateTime
      methodName: execute
  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
