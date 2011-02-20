#!/bin/sh

plackup -p 9000 -E deployment bin/app.psgi > log/app.log 2>&1 &

