#/bin/bash

# import the public key
curl -fsSL https://pgp.mongodb.com/server-6.0.pub | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg &&

# create a list file for MongoDB (Ubuntu 18.04)
echo "deb [ arch=amd64,arm64 signed=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list &&

# reload local package
sudo apt-get update &&

# Install MongoDB package
sudo apt-get install -y mongodb-org &&

# data /var/lib/mongodb and log /var/log/mongodb
# config file /etc/mongod.conf

# start service
sudo systemctl daemon-reload &&
sudo systemctl enable mongod &&
sudo systemctl start mongod &&

# allow permission
sudo chown mongodb:mongodb /tmp/mongodb-27017.sock &&
sudo chown -R mongodb:mongodb /var/log/mongodb &&
sudo chown -R mongodb:mongodb /var/lib/mongod
