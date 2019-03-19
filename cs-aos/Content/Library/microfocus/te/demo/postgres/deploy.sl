namespace: microfocus.te.demo.postgres
flow:
  name: deploy
  inputs:
  - hostname
  - username
  - password:
      sensitive: true
  workflow:
  - install_pkgs:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: yum install -y postgresql-server postgresql-contrib
        - username: '${username}'
        - password:
            value: '${password}'
            sensitive: true
      navigate:
      - SUCCESS: create_db_cluster
      - FAILURE: on_failure
  - create_db_cluster:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: postgresql-setup initdb
        - username: '${username}'
        - password:
            value: '${password}'
            sensitive: true
      navigate:
      - SUCCESS: enable_md5
      - FAILURE: on_failure
  - enable_md5:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: sed -i s/ident/md5/g /var/lib/pgsql/data/pg_hba.conf
        - username: '${username}'
        - password:
            value: '${password}'
            sensitive: true
      navigate:
      - SUCCESS: listen_address
      - FAILURE: on_failure
  - enable_autostart:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: systemctl enable postgresql
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
        - command: systemctl restart postgresql
        - username: '${username}'
        - password:
            value: '${password}'
            sensitive: true
      navigate:
      - SUCCESS: firewall_cfg
      - FAILURE: on_failure
  - firewall_cfg:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: 'firewall-cmd --get-active-zones && firewall-cmd --zone=public --add-port=5432/tcp --permanent && firewall-cmd --reload'
        - username: '${username}'
        - password:
            value: '${password}'
            sensitive: true
      navigate:
      - SUCCESS: SUCCESS
      - FAILURE: on_failure
  - listen_address:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: 'sed -i s/localhost/*/g /var/lib/pgsql/data/postgresql.conf'
        - username: '${username}'
        - password:
            value: '${password}'
            sensitive: true
      navigate:
      - SUCCESS: activate_lister
      - FAILURE: on_failure
  - activate_lister:
      do:
        io.cloudslang.base.ssh.ssh_command:
        - host: '${hostname}'
        - command: 'sed -i s/#listen_addresses/listen_addresses/g /var/lib/pgsql/data/postgresql.conf'
        - username: '${username}'
        - password:
            value: '${password}'
            sensitive: true
      navigate:
      - SUCCESS: enable_autostart
      - FAILURE: on_failure
  results:
  - FAILURE
  - SUCCESS
extensions:
  graph:
    steps:
      install_pkgs:
        x: 29
        y: 74
      create_db_cluster:
        x: 20
        y: 227
      enable_md5:
        x: 145
        y: 81
      enable_autostart:
        x: 261
        y: 234
      start:
        x: 396
        y: 87
      firewall_cfg:
        x: 401
        y: 237
        navigate:
          291a3aff-16c6-935c-40b5-04519c9a8f0b:
            targetId: d681f850-5396-b4b0-bc1a-25a9c90c11ba
            port: SUCCESS
      listen_address:
        x: 140
        y: 225
      activate_lister:
        x: 266
        y: 84
    results:
      SUCCESS:
        d681f850-5396-b4b0-bc1a-25a9c90c11ba:
          x: 528
          y: 253