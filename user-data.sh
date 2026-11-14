#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get -o Acquire::Retries=3 update
apt-get -o Acquire::Retries=3 install -y nginx

cat > /var/www/html/index.nginx-debian.html <<'HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Terraform Nginx Lab</title>
</head>
<body>
  <main>
    <h1>Terraform Nginx Lab</h1>
    <p>Nginx is running on an Ubuntu EC2 t2.micro instance.</p>
    <p>This custom page was installed using EC2 user data.</p>
  </main>
</body>
</html>
HTML

nginx -t
systemctl enable --now nginx
