#!/bin/bash

echo -n "This deletes current databases, shared files, and docker images.  Continue? (y/n) "
read CONFIRM

if [[ "$CONFIRM" =~ ^[yY].* ]]; then
    echo Proceeding
else
    echo Quitting
    exit 0
fi

# Delete old stig containers and images
sudo docker stop stig
sudo docker container rm stig
sudo docker image rm stig

# Delete old database configurations
sudo rm -rf orientdb_backup orientdb_config orientdb_databases share_dir

# Generate a local ssh key, needed when building image
if ! [ -f ./id_rsa.pub ]; then ssh-keygen -f ./id_rsa -P ""; fi

# Build the docker image
sudo docker build -t stig .

# Setup the STIG database
./setup_database.sh
