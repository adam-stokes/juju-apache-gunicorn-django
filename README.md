juju-apache-gunicorn-django
===========================

Example charm repository for setting up Apache+SSL, gunicorn, django, and postgresql.

## Prep

### get latest charm

```
$ git clone git@github.com:battlemidget/juju-apache-gunicorn-django.git
```

### tar up django application

```
tar -cjf charms/precise/django-deploy-charm/files/djangoapp.tar.bz2 -C django-app .
```


## Deploy

```
juju bootstrap

### Deploy the application charm
juju deploy --repository ./charms local:django-deploy-charm

### Deploy the application server
juju deploy gunicorn
juju add-relation gunicorn django-deploy-charm

### Deploy the http server to proxy requests to application server and handle static content
juju deploy apache2
juju add-relation apache2:reverseproxy django-deploy-charm

### Set apache specific config options, needs to run after deploying apache2 and django-deploy-charm
juju set apache2 "vhost_https_template=$(base64 < templates/apache_vhost.tmpl)"
juju set apache2 "enable_modules=ssl proxy proxy_http proxy_connect rewrite headers"
juju set apache2 "ssl_keylocation=ssl-cert-cts.key"
juju set apache2 "ssl_certlocation=ssl-cert-cts.pem"
juju set apache2 "ssl_cert=SELFSIGNED"

### Deploy database and link it to web application
juju deploy postgresql
juju add-relation django-deploy-charm:db postgresql:db

### Expose service
juju expose apache2
```
