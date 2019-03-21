namespace: io.cloudslang.microfocus.te.demo.postgres
flow:
  name: undeploy
  inputs:
    - hostname
    - username:
        default: "${get_sp('te.demo.vcenter.username')}"
        required: false
    - password:
        default: "${get_sp('te.demo.vcenter.password')}"
        required: false
        sensitive: true
  workflow:
    - install_pkgs:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${hostname}'
            - command: yum remove -y postgresql-server postgresql-contrib
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_pkgs:
        x: 232
        y: 132
        navigate:
          8998de1f-c4c9-69b5-887b-cf63fda6a9f5:
            targetId: d0b408af-52a5-8f5b-6074-3df759e2732d
            port: SUCCESS
    results:
      SUCCESS:
        d0b408af-52a5-8f5b-6074-3df759e2732d:
          x: 493
          y: 136
