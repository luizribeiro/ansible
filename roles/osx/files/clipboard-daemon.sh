#!/bin/env bash
HOST=127.0.0.1
PORT=52698

NCAT=$(command -v ncat nc | head -1)

while true; do
    $NCAT -l ${HOST} ${PORT} | pbcopy
done
