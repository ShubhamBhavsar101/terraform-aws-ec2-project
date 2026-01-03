#! /bin/bash
# shellcheck disable=SC2164

APP_USER="ubuntu"
APP_DIR="/home/ubuntu/python-mysql-db-proj-1"
REPO_URL="https://github.com/ShubhamBhavsar101/python-mysql-db-proj-1.git"

cd /home/ubuntu
yes | sudo apt update
yes | sudo apt install python3 python3-pip python3-venv
git clone $REPO_URL
sleep 20


# shellcheck disable=SC2164
cd python-mysql-db-proj-1
chown -R $APP_USER:$APP_USER $APP_DIR

sudo -u $APP_USER bash << EOF
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
echo 'Waiting for 30 seconds before running the app.py'
sleep 30
setsid python3 -u app.py &
EOF


