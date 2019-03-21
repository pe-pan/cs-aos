########################################################################################################################
#!!
#! @input hostname: VM where Fortify SCA is installed
#! @input sourceanalyzer: Full fie path where is the scan.sh script placed
#! @input url: Git repository URL
#! @input folder: Sub-folder of the repo to be scanned
#! @input level: Which level of security issues to scan the code for
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.te.demo.sca
flow:
  name: scan
  inputs:
    - hostname:
        default: "${get_sp('te.demo.fortify.hostname')}"
        required: false
    - username:
        default: "${get_sp('te.demo.fortify.username')}"
        required: false
    - password:
        default: "${get_sp('te.demo.fortify.password')}"
        required: false
        sensitive: true
    - sourceanalyzer:
        default: "${get_sp('te.demo.fortify.sourceanalyzer')}"
        required: false
    - url:
        default: "${get_sp('te.demo.aos.url')}"
        required: false
    - folder:
        default: "${get_sp('te.demo.fortify.folder')}"
        required: false
    - level:
        default: "${get_sp('te.demo.fortify.level')}"
        required: false
  workflow:
    - calculate_score:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: "${get('hostname', get_sp('te.demo.fortify.hostname'))}"
            - command: "${get('sourceanalyzer')+' '+get('url')+' '+get('folder')+' '+get('level')}"
            - username: "${get('username', get_sp('te.demo.fortify.username'))}"
            - password:
                value: "${get('password', get_sp('te.demo.fortify.password'))}"
                sensitive: true
        publish:
          - score: '${standard_out}'
          - command_return_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - score: '${score}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      calculate_score:
        x: 308
        y: 112
        navigate:
          b03dd691-4a60-d59f-7df9-73a1d50ccbc4:
            targetId: 5917fca4-8efd-d214-2a6f-f263d04967e5
            port: SUCCESS
    results:
      SUCCESS:
        5917fca4-8efd-d214-2a6f-f263d04967e5:
          x: 456
          y: 112
