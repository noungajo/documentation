# Envoie d'e-mail via django

## Liste clients e-mail acceptes
- gmail: smtp.gmail.com
- outlook: smtp-mail.outlook.com
- yahoo: smtp.mail.yahoo.com

## Setting.py

```shell
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'client e-mail'
EMAIL_USE_TLS = True
EMAIL_PORT = 587
EMAIL_HOST_USER = "sender's email-id"
EMAIL_HOST_PASSWORD = 'password associated with above email-id'
```

> Concernant les adresses gmail le **EMAIL_HOST_PASSWORD** doit etre un token genere dans le compte google. Pour outlook le mot de passe suffit.

## Views.py

```python
from django.conf import settings
from django.core.mail import send_mail

# dans la fonction souhaite il faut appeller ce pour de code pour envoyer un email
send_mail(subject,body,email_from,recipient_list)
```
Une autre approche est de creer une fonction qui va envoyer l'email

```python
from django.core.mail import EmailMessage, get_connection
from django.conf import settings
def send_email(subject,body,recipient_email):
    with get_connection(host=settings.EMAIL_HOST,port = settings.EMAIL_PORT,username=settings.EMAIL_HOST_USER,password=settings.EMAIL_HOST_PASSWORD,use_tls=settings.EMAIL_USE_TLS) as connection:
        email_from = settings.EMAIL_HOST_USER
        recipient_list = [recipient_email,]
        EmailMessage(subject,body, email_from, recipient_list,connection=connection).send()
```
