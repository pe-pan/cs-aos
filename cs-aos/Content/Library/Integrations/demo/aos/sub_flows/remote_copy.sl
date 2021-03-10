########################################################################################################################
#!!
#! @description: Downloads the file from the given URL and copies it to the remote VM. If no password is given, it uses the private key file to connect to the remote VM.
#!
#! @input host: VM where to copy the file
#! @input username: VM username
#! @input password: VM password; if not given, private key file is used instead
#! @input url: Where to download the file from
#!!#
########################################################################################################################
namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host
    - username
    - password:
        required: false
        sensitive: true
    - url
  workflow:
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - auth_type: anonymous
            - destination_file: '${url[url.rfind("/")+1:]}'
            - method: GET
        publish:
          - filename: '${destination_file}'
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: "${get_sp('script_location')}"
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
            - destination_private_key_file: "${get_sp('aws_cert_file_path') if password is None else None}"
            - known_hosts_policy: null
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - filename: '${filename}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_file:
        x: 100
        'y': 249
      remote_secure_copy:
        x: 283
        'y': 247
        navigate:
          94ad61f2-64c4-a3a5-1647-6eb06ac1b687:
            targetId: 1a4b4e41-715c-4454-4553-8668c9592a94
            port: SUCCESS
    results:
      SUCCESS:
        1a4b4e41-715c-4454-4553-8668c9592a94:
          x: 275
          'y': 95
