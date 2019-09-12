#!/bin/bash

# Delete old stig containers and images
sudo docker stop stig
sudo docker container rm stig
sudo docker image rm stig

# Generate a local ssh key, needed when building image
if ! [ -f ./id_rsa.pub ]; then ssh-keygen -f ./id_rsa -P ""; fi

# Build the docker image
sudo docker build -t stig .
