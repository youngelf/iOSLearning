#!/bin/bash

# Take the first argument and ldid it and then send it to the
# device indicated on the third argument

./ldid -S $1/$2
rm -Rf ~/Deploy/*
mv $1 ~/Deploy/

scp -r ~/Deploy/* root@192.168.11.${3}:


