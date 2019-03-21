########################################################################################################################
#!!
#! @output host: If empty, the host is not reachable. If not empty, it contains the IP of the just initialized VM.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.te.demo.aos
flow:
  name: clean_vm
  inputs:
    - hostname: 10.3.62.30
    - username:
        default: "${get_sp('te.demo.vcenter.username')}"
        required: false
        sensitive: true
    - password:
        default: "${get_sp('te.demo.vcenter.password')}"
        required: false
  workflow:
    - is_accessible:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${hostname}'
            - command: pwd
            - username: "${get('username', get_sp('te.demo.vcenter.username'))}"
            - password:
                value: "${get('password', get_sp('te.demo.vcenter.password'))}"
                sensitive: true
        publish:
          - host: ''
        navigate:
          - SUCCESS: uninstall_all
          - FAILURE: SUCCESS
    - uninstall_all:
        do:
          io.cloudslang.demo.aos.sub_flows.initialize_artifact:
            - host: '${hostname}'
            - username: "${get('username', get_sp('te.demo.vcenter.username'))}"
            - password: "${get('password', get_sp('te.demo.vcenter.password'))}"
            - script_url: "${get_sp('te.demo.aos.script_uninstall_all')}"
        publish:
          - host
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - host: '${host}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_accessible:
        x: 329
        y: 95
        navigate:
          48fbd459-b7ad-925d-0508-f008514c9991:
            targetId: bc153e39-6107-18da-338d-99e8ea72b430
            port: FAILURE
      uninstall_all:
        x: 322
        y: 270
        navigate:
          8b5a762f-edd2-cd6d-4cdd-acae8ad62599:
            targetId: bc153e39-6107-18da-338d-99e8ea72b430
            port: SUCCESS
    results:
      SUCCESS:
        bc153e39-6107-18da-338d-99e8ea72b430:
          x: 545
          y: 264
