sudo apt-get install apache2 mysql-client mysql-server

sudo apt-get install libapache2-mod-wsgi

sudo a2enmod wsgi

cd /var/www/

mkdir FlaskApp

cd FlaskApp

mkdir static
mkdir templates


cat>>__init__.py<<EOF
from flask import Flask

app = Flask(__name__)

@app.route('/')
def homepage():
    return "Hi there, how ya doin?"


if __name__ == "__main__":
    app.run()
EOF

apt-get update
apt-get upgrade


pip3 install virtualenv

python3 -m venv myvenv

source myvenv/bin/activate

pip install Flask

python __init__.py

cat>>/etc/apache2/sites-available/FlaskApp.conf<<EOF
<VirtualHost *:80>
                ServerName 52.78.133.174
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

sudo a2ensite FlaskApp
service apache2 reload

cd /var/www/FlaskApp
cat>>flaskapp.wsgi<<EOF
#!/usr/bin/python
import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,"/var/www/FlaskApp/")

from FlaskApp import app as application
application.secret_key = 'your secret key. If you share your website, do NOT share it with this key.'
EOF

service apache2 restart
