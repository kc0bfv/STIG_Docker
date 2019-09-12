#!/bin/bash

mkdir -p share_dir

sudo docker kill stig
sudo docker rm stig

sudo docker run -v "$(pwd)/share_dir:/root/share_dir" --name stig stig

sudo docker kill stig
sudo docker rm stig
