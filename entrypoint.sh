#!/bin/bash
set -e

# remove any existing pids
rm -f /api/tmp/pids/server.pid

# start the server
exec "$@"