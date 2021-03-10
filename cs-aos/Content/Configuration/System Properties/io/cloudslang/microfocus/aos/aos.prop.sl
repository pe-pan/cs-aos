namespace: ''
properties:
  - script_location: /tmp
  - script_retries: '5'
  - script_deploy_war: 'http://httpserver.dca.swdemos.net:6500/aos/scripts/deploy_war.sh'
  - script_install_java: 'http://jenkins.hcmx.local:8080/job/AOS-repo/ws/install_java.sh'
  - script_install_postgres: 'http://httpserver.dca.swdemos.net:6500/aos/scripts/install_postgres.sh'
  - script_install_tomcat: 'http://jenkins.hcmx.local:8080/job/AOS-repo/ws/install_tomcat.sh'
  - script_downgrade_java: 'http://httpserver.dca.swdemos.net:6500/aos/scripts/downgrade_java_to_8.sh'
  - script_configure_azure_postgres: 'http://httpserver.dca.swdemos.net:6500/aos/scripts/configure_azure_postgres.sh'
  - war_repo_root_url: 'http://httpserver.dca.swdemos.net:6500/aos/artifact/'
  - aws_cert_file_path: /etc/dnd/cacerts/titan-hcmx-aws.pem
