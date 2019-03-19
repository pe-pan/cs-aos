namespace: io.cloudslang.microfocus.te.demo.tomcat
flow:
  name: deploy
  inputs:
  - hostname
  - username
  - password:
      sensitive: true
  workflow:
  - deploy_packages:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: yum install -y tomcat tomcat-webapps tomcat-admin-webapps
        - username: '${username}'
        - password:
            value: '${password}'
            sensitive: true
        - timeout: '900000'
      navigate:
      - SUCCESS: config_engine
      - FAILURE: on_failure
  - config_engine:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: "echo -e \\\"JAVA_OPTS\\\"=\\\"-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xmx512m -XX:MaxPermSize=256m -XX:+UseConcMarkSweepGC\\\" >> /usr/share/tomcat/conf/tomcat.conf"
        - username: '${username}'
        - password:
            value: '${password}'
            sensitive: true
      navigate:
      - SUCCESS: admin_user
      - FAILURE: on_failure
  - enable_autostart:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: systemctl enable tomcat
        - username: '${username}'
        - password:
            value: '${password}'
            sensitive: true
      navigate:
      - SUCCESS: start
      - FAILURE: on_failure
  - start:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: systemctl start tomcat
        - username: '${username}'
        - password:
            value: '${password}'
            sensitive: true
      navigate:
      - SUCCESS: firewall_cfg
      - FAILURE: on_failure
  - admin_user:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: "echo -e \"<tomcat-users>\n<user username=\\\"\"admin\\\"\" password=\\\"\"password\\\" roles=\\\"\"manager-gui,admin-gui\\\"/>\n</tomcat-users>\n\" > /usr/share/tomcat/conf/tomcat-users.xml"
        - username: '${username}'
        - password:
            value: '${password}'
            sensitive: true
      navigate:
      - SUCCESS: enable_autostart
      - FAILURE: on_failure
  - firewall_cfg:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: 'firewall-cmd --get-active-zones && firewall-cmd --zone=public --add-port=8080/tcp --permanent && firewall-cmd --reload'
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
      deploy_packages:
        x: 155
        y: 44
      config_engine:
        x: 159
        y: 249
      enable_autostart:
        x: 307
        y: 419
      start:
        x: 490
        y: 428
      admin_user:
        x: 151
        y: 429
      firewall_cfg:
        x: 490
        y: 256
        navigate:
          8bf5bd47-2b8b-5afe-4eb6-af72ed77ac16:
            targetId: 7d9d6378-52d5-84be-6ef3-56b0cd9260ed
            port: SUCCESS
    results:
      SUCCESS:
        7d9d6378-52d5-84be-6ef3-56b0cd9260ed:
          x: 480
          y: 60