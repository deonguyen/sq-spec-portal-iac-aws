#!/bin/bash
yum update -y
yum install -y python3-pip httpd-tools

pip3 install pypiserver[s3] boto3

# Create a directory for packages and the password file
mkdir -p /var/www/pypi

# Create the .htpasswd file for authentication
htpasswd -bc /var/www/pypi/.htpasswd ${pypi_user} ${pypi_password}

cat <<EOF > /etc/systemd/system/pypiserver.service
[Unit]
Description=PyPI Server
[Service]
ExecStart=/usr/local/bin/pypi-server -p 8080 -P /var/www/pypi/.htpasswd --backend s3 --s3-bucket ${pypi_bucket_name} --s3-region ${aws_region} /var/www/pypi
[Install]
WantedBy=multi-user.target
EOF

systemctl enable --now pypiserver.service