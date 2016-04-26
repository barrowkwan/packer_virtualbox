#!/bin/sh

# Installing vagrant keys
mkdir -pm 0700 /home/vagrant/.ssh
cat << EOF > /home/vagrant/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDSHBQpmCUEpGKyNFFMZN5VdIkWjDaBVd87CFYelgLgrlq7A96VrCkWU6/PxJJKvNtE/tkwpOVlmnt27Ln0NkUd1KEGpeIsnqXlS9k70eE9U+g2nuxTApG5dVQ3d2gZcAj+nh0OFNvKzDhFYWs0ovSxdmA6WL1bjDYMTwVjnObCWHFN/99sSeGvHbcEUbEZrteNacij1h7cZ+39KaZgrpCqEOL2n7UWzymuDBN8B5g1Bwi5qh6NpQMhIYFmVZh0RxiSjgUKwBwGAD+w19B01R0g4kBfkKgcTT3SAIaG6hnebiDkDvr7SjyFlalvj23flfh71Punt4m2pTh3ThDshPQ4MjH4yhZAqzJyHqaFexswn7t1DSA6CvCfL/oqFQjROHFDwlZOVoXtn8GpHh/uDcAzwLhe4+yaq8/j+efrLpMyAjEpuyux20Ai/POvwNae1I7GfCdMT5ELZwKtfUbZXrggLDRg2/h2l7K5dsR80tofF0htb1yYtH5kfbrnFKxex1xkS6RZmZ+A3Tszue5dIBynu4z1bKj2LN4kLAvYY6J/CxxS+WCNVjfUq3AdGaqNvztGIM+jPHk02zzdFCEEmhOtV3ZQCtjMEKHZohuIAcOP1acf0qR4Y/p4hKIN7doNDVksd5O5FJszcaSd5PXbDLhDw0LaNT/JWipiVfE1rQiBGQ== VirtualBox SSH Key
EOF
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "Defaults:vagrant !requiretty" > /etc/sudoers.d/vagrant
echo "Defaults:root !requiretty" >> /etc/sudoers.d/vagrant
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
