#!/bin/sh
set -e

start_handler() {
  /usr/local/bin/nats-server --config /etc/nats/nats-server.conf
}

trap 'kill ${!}; start_handler' SIGUSR1

# wait forever
echo "Waiting forever to SIGUSR1 to start NATS..."
while true
do
  tail -f /dev/null & wait ${!}
done
