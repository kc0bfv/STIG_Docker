#!/bin/bash

mkdir -p orientdb_config
mkdir -p orientdb_databases
mkdir -p orientdb_backup

sudo docker kill stig
sudo docker rm stig

# Setup the orientdb database
sudo docker run -v "$(pwd)/orientdb_config:/orientdb/config" -v "$(pwd)/orientdb_databases:/orientdb/databases" -v "$(pwd)/orientdb_backup:/orientdb/backup" --name stig stig bash -c "(ORIENTDB_ROOT_PASSWORD=admin /orientdb/bin/server.sh &); (while ! nc -z localhost 2424; do echo Waiting for OrientDB; sleep 1; done); (cd /root/STIG/db_setup; ORIENTDB_HOME=/orientdb ./setup.sh) && (echo 'SET ignoreErrors true;DROP DATABASE remote:localhost/stig root admin plocal;SET ignoreErrors false;CREATE DATABASE remote:localhost/stig root admin plocal; IMPORT DATABASE /root/STIG/db_setup/stig.gz -preserveClusterIDs=true; SLEEP 1000' > /tmp/updated_import_db.txt) && /orientdb/bin/console.sh /tmp/updated_import_db.txt; /orientdb/bin/shutdown.sh"

sudo docker kill stig
sudo docker rm stig

