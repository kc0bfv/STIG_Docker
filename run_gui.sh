#!/bin/bash

# Wait for SSH to be available in the target docker container
while ! nc -z 172.17.0.2 22; do echo Waiting for SSH; sleep 1; done

# SSH into docker container, start up STIG, forwarding back the visuals
ssh root@172.17.0.2 -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile /dev/null" -i ./id_rsa 'PATH=$PATH:/usr/local/openjdk-8/bin; xauth add $(xauth list $DISPLAY); (while ! nc -z localhost 2424; do echo Waiting for OrientDB; sleep 1; done); cd STIG; xfe &; npm start'
