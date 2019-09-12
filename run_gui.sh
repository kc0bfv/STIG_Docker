while ! nc -z 172.17.0.2 22; do echo Waiting for SSH; sleep 1; done

ssh root@172.17.0.2 -i ./id_rsa 'PATH=$PATH:/usr/local/openjdk-8/bin; xauth add $(xauth list $DISPLAY); echo here; (while ! nc -z localhost 2424; do echo Waiting for OrientDB; sleep 1; done); cd STIG; npm start'
