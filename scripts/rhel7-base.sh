#!/bin/sh


# timezone above in this kickstart script did not work.
/usr/bin/timedatectl set-timezone America/Los_Angeles

/bin/echo 'UseDNS no' >> /etc/ssh/sshd_config
