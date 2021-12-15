#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SERVER_IP=`hostname -I`
sed -i -e "s/SERVER_IP/${SERVER_IP//[[:space:]]/}/g" server.conf

echo "RUNNING"

$SCRIPT_DIR/sccache-dist $*