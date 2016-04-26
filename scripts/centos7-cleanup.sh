#!/bin/sh

rm -rf /tmp/*
rm -rf /var/log/yum.log
rm -rf /var/lib/yum/*

rm -f /var/log/wtmp /var/log/btmp

history -c
