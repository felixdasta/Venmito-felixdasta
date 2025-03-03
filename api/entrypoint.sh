#!/bin/bash

echo "Starting Nginx in the background with self-signed cert..."
nginx &

# Wait briefly for Nginx to come up
sleep 2

echo "Reloading Nginx..."
nginx -s reload

echo "Starting Gunicorn in the foreground..."
exec gunicorn --threads 2 -b 127.0.0.1:8000 api.app:app
