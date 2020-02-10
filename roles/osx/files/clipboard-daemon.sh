#!/bin/bash
HOST=127.0.0.1
PORT=52698

while [ true ]; do
    /usr/bin/nc -l ${HOST} ${PORT} | pbcopy
done
