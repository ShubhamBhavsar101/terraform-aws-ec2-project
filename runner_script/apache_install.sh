#!/bin/bash

apt update
apt install apache2 -y
systemctl start apache2
systemctl enable apache2

echo "<html><body><h1>Welcome to Apache Server</h1>
<h2> This Server name is $(hostname) </h2>
</body></html>" > /var/www/html/index.html