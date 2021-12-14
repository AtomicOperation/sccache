#!/bin/bash

SERVER_IP=`hostname -I`
sed -i -e "s/SERVER_IP/${SERVER_IP//[[:space:]]/}/g" server.conf

/opt/sccache/sccache-dist server --config server.conf