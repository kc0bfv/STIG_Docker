# This dockerfile sets up all requirements for the STIG, https://github.com/idaholab/STIG
# STIG depends on orientdb being accessible locally.  Currently, it'll become part of the Docker container.  A better solution, that's more scalable, might be to have orientdb run in a separate container...

# Orientdb's Dockerfile is based on "openjdk:8-jdk-slim", which is in-turn based on "debian:buster-slim".  Therefore, the result also already includes openjdk-8 and debian buster.
FROM orientdb

# Setup prerequisites
RUN apt update
RUN apt install -y build-essential libssl-dev apt-transport-https curl git gnupg netcat libglib2.0-0 libnss3 libgtk-3-0 libx11-xcb1 libxss1 libasound2 openssh-server xfe

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
# Starts orientdb and an SSH server in parallel
CMD /bin/bash -c '(export ORIENTDB_ROOT_PASSWORD=admin; /orientdb/bin/server.sh &); /usr/sbin/sshd -D'
