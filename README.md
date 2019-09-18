# Structured Threat Intelligence Graph (STIG) Execution Via Docker

## Purpose
Make setup and execution of [STIG](https://github.com/idaholab/STIG) simpler.  With this, it's simplified to just running a couple scripts.

The result is a standardized docker image on your local machine, with STIG database state stored in the execution directory.

## Prerequisites
You must have docker, sudo, netcat, and standard Linux SSH client tools (ssh, ssh-keygen) installed.

You must be a user capable of running arbitrary commands as sudo.

## Usage
First, build the "stig" Docker image: `./rebuild.sh`

Next, run the STIG server: `./start_server.sh`

Finally, open a separate command shell and run the GUI to connect to the server: `./run_gui.sh`

## Stopping the Server
Run `./stop.sh`

## Resetting the Database
STIG database information, and database configuration, is stored in the directory you run `rebuild.sh` from.  If you want to wipe that database out and rebuild it you can delete the `orientdb_*` directories and run `./setup_database.sh`.  This is generally not necessary.  If you want separate databases in separate directories, perhaps to simplify execution in some use case, `setup_database.sh` in the new directory would accomplish that for you without rebuilding the STIG image.
