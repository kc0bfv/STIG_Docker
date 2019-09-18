# This dockerfile sets up all requirements for the STIG, https://github.com/idaholab/STIG
# STIG depends on orientdb being accessible locally.  Currently, it'll become part of the Docker container.  A better solution, that's more scalable, might be to have orientdb run in a separate container...

# Orientdb's Dockerfile is based on "openjdk:8-jdk-slim", which is in-turn based on "debian:buster-slim".  Therefore, the result also already includes openjdk-8 and debian buster.
FROM orientdb

# Setup prerequisites
RUN apt update
RUN apt install -y build-essential libssl-dev apt-transport-https curl git gnupg netcat libglib2.0-0 libnss3 libgtk-3-0 libx11-xcb1 libxss1 libasound2 openssh-server

# Setup Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt install -y --no-install-recommends yarn

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN /bin/bash -c '. /root/.nvm/nvm.sh && nvm install node'

# Download STIG and install dependencies
WORKDIR /root
RUN git clone https://github.com/idaholab/STIG.git
RUN cd STIG && /bin/bash -c '. /root/.nvm/nvm.sh && npm install'


# Setup SSH so we can forward our screen back
RUN sed "s/#X11UseLocalhost yes/X11UseLocalhost no/;s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config > /tmp/sshd_config && mv /tmp/sshd_config /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd
RUN echo -e 'xauth list $DISPLAY\nxauth add ...' > /tmp/xauth_howto                                                                                                                 
COPY id_rsa.pub /root/.ssh/authorized_keys                                                                                                                                          

# Setup and start orientdb database and SSH
#CMD (ORIENTDB_ROOT_PASSWORD=admin /orientdb/bin/server.sh &); (while ! nc -z localhost 2424; do echo Waiting for OrientDB; sleep 1; done); (cd /root/STIG/db_setup; ORIENTDB_HOME=/orientdb ./setup.sh) && (echo 'SET ignoreErrors true;DROP DATABASE remote:localhost/stig root admin plocal;SET ignoreErrors false;CREATE DATABASE remote:localhost/stig root admin plocal; IMPORT DATABASE /root/STIG/db_setup/stig.gz -preserveClusterIDs=true; SLEEP 1000' > /tmp/updated_import_db.txt) && /orientdb/bin/console.sh /tmp/updated_import_db.txt; ls /orientdb/databases; /usr/sbin/sshd -D

# For debugging...
#ENTRYPOINT /bin/bash
#CMD ["/usr/sbin/sshd", "-D"]

# Maybe actual command...
#ENTRYPOINT (export ORIENTDB_ROOT_PASSWORD=admin; /orientdb/bin/server.sh &); (while ! nc -z localhost 2424; do echo Waiting for OrientDB; sleep 1; done); npm start
ENTRYPOINT /orientdb/bin/server.sh
