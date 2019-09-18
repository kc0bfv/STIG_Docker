#!/bin/bash

mkdir -p share_dir

sudo docker kill stig
sudo docker rm stig

sudo docker run -v "$(pwd)/share_dir:/root/share_dir" -v "$(pwd)/orientdb_config:/orientdb/config" -v "$(pwd)/orientdb_databases:/orientdb/databases" -v "$(pwd)/orientdb_backup:/orientdb/backup" --name stig stig

sudo docker kill stig
sudo docker rm stig
