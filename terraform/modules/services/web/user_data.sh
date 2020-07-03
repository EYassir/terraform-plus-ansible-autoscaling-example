#!/bin/bash
# 1 - créer un fichier dans les sudoers.d/ avec la configuration suivante
# nom_user_slave ALL=(ALL) NOPASSWD:ALL
cat << EOF > /etc/sudoers.d/${slave_user}
# User rules for ${slave_user}
${slave_user} ALL=(ALL) NOPASSWD:ALL
EOF

# create slave user
useradd -m -s /bin/bash ${slave_user}

# drop in master SSH public authorized key
# créer le dosier .ssh du user slave
# /home/my_user_slave/.ssh
mkdir -p /home/${slave_user}/.ssh
# Ajouter la clé publique de l'utilisateur master dans les authorized_keys
# echo "ssh-rsa kjfhkjefhjkdhfkjdfhkjdf > /home/user_slave/.ssh/authorized_keys"
echo ${master_public_key} > /home/${slave_user}/.ssh/authorized_keys
chown -R ${slave_user}:${slave_user} /home/${slave_user}/.ssh
# modifier les droit du dossier .ssh
chmod 700 /home/${slave_user}/.ssh
# modifier les droit du fichier authorized_keys
chmod 600 /home/${slave_user}/.ssh/authorized_keys

# Ansible required dependency
apt install -y python

# créer la ppage template
cat > index.html <<EOF
<h1>Hello, World</h1>
EOF

nohup busybox httpd -f -p 8080 &
