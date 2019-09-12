# Structured Threat Intelligence Graph (STIG) Execution Via Docker

## Purpose
Make setup and execution of STIG simpler.  With this, it's simplified to just running a couple scripts.

## Prerequisites
You must have docker, netcat, and standard Linux SSH client tools (ssh, ssh-keygen) installed.

## Usage
First, build the "stig" Docker image: `./build.sh`

Next, run the STIG server: `./start_server.sh`

Finally, open a separate command shell and run the GUI to connect to the server: `./run_gui.sh`

When running the server, first the database has to get updated.  This'll take a minute.  Open the GUI at any time though, because the script starts by waiting for the SSH server to be available.
