cd /

apt-get update

apt-get upgrade

apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils

curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash


cat>>.bashrc<<EOF
export PATH="~/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF

source .bashrc

pyenv update

pyenv install 3.6.0

pyenv global 3.6.0

apt-get install apache2 mysql-client mysql-server

apt-get install libapache2-mod-wsgi

a2enmod wsgi

cd /var/www/

mkdir FlaskApp

cd FlaskApp

mkdir FlaskApp

cd FlaskApp/

mkdir static

mkdir templates


cat>>__init__.py<<EOF
from flask import Flask

app = Flask(__name__)

@app.route('/')
def homepage():
    return "Hi there, how about tonight?"


if __name__ == "__main__":
    app.run()
EOF

apt-get update

apt-get upgrade


pip install --upgrade pip

pip install Flask

python __init__.py

cat>>/etc/apache2/sites-available/FlaskApp.conf<<EOF
<VirtualHost *:80>
                ServerName 52.78.162.71
                ServerAdmin zhuiox@email.com
                WSGIScriptAlias / /var/www/FlaskApp/flaskapp.wsgi
                <Directory /var/www/FlaskApp/FlaskApp/>
                        Order allow,deny
                        Allow from all
                </Directory>
                Alias /static /var/www/FlaskApp/FlaskApp/static
                <Directory /var/www/FlaskApp/FlaskApp/static/>
                        Order allow,deny
                        Allow from all
                </Directory>
                ErrorLog ${APACHE_LOG_DIR}/error.log
                LogLevel warn
                CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

a2ensite FlaskApp
service apache2 reload

cd /var/www/FlaskApp
cat>>flaskapp.wsgi<<EOF
#!/usr/bin/python
import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,"/var/www/FlaskApp/")

from FlaskApp import app as application
application.secret_key = 'ewfwefwefewfwef'
EOF

service apache2 restart
