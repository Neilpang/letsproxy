#!/bin/bash

rm -f /etc/nginx/socks/*



exec /app/docker-entrypoint.sh  "$@"


