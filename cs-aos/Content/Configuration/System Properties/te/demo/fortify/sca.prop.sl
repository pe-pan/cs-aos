namespace: te.demo.fortify
properties:
  - hostname: vmdocker2
  - username: root
  - password:
      value: Police123
      sensitive: true
  - sourceanalyzer: /opt/Fortify/scan.sh
  - folder: aos/accountservice/src/main/java/com/advantage/accountsoap/services
  - level: critical
