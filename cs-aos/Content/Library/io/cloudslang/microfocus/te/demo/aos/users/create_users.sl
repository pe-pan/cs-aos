namespace: io.cloudslang.microfocus.te.demo.aos.users
flow:
  name: create_users
  inputs:
    - file_host
    - file_user
    - file_password
    - file_path
    - db_host
    - db_user
    - db_password
    - mm_url
    - mm_user
    - mm_password
    - mm_chanel_id
  workflow:
    - read_users:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${file_host}'
            - command: "${'cat '+file_path}"
            - username: '${file_user}'
            - password:
                value: '${file_password}'
                sensitive: true
        publish:
          - file_content: '${return_result}'
        navigate:
          - SUCCESS: create_user
          - FAILURE: on_failure
    - create_user:
        loop:
          for: credentials in file_content.split()
          do:
            io.cloudslang.microfocus.te.demo.aos.users.create_user:
              - credentials: '${credentials}'
              - file_host: '${file_host}'
              - file_user: '${file_user}'
              - file_password: '${file_password}'
              - db_host: '${db_host}'
              - db_user: '${db_user}'
              - db_password: '${db_password}'
              - mm_url: '${mm_url}'
              - mm_user: '${mm_user}'
              - mm_password: '${mm_password}'
              - mm_chanel_id: '${mm_chanel_id}'
          break: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      read_users:
        x: 76
        'y': 103
      create_user:
        x: 289
        'y': 106
        navigate:
          f4288d4b-8ebb-5a28-1f60-ec42cdd5a3d6:
            targetId: 3df8d638-80de-08c8-c8c2-a1db108af546
            port: SUCCESS
    results:
      SUCCESS:
        3df8d638-80de-08c8-c8c2-a1db108af546:
          x: 467
          'y': 112
