namespace: io.cloudslang.microfocus.te.demo.tomcat
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
    - remove_tomcat:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${hostname}'
            - command: yum remove -y tomcat tomcat-webapps tomcat-admin-webapps
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
      remove_tomcat:
        x: 202
        y: 187
        navigate:
          7f8258e7-b2d6-aa03-1d56-02544b82d2b9:
            targetId: 83604d53-16a8-c30c-2904-2463222e9b3c
            port: SUCCESS
    results:
      SUCCESS:
        83604d53-16a8-c30c-2904-2463222e9b3c:
          x: 584
          y: 174
