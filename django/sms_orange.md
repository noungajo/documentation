Cet extrait va en bref expliquer comment envoyer des sms via le bundle de orange.
préréquis:
- Posséder un compte utilisateur sur le site [Orange Developer](https://developer.orange.com/)
- Une fois connecter sélectionner MyApp pour afficher la liste des applications(s'il n'y a aucune application configurer votre application)
- Récupérer son en tête d'autorisation pour le compte actuel l'en tête d'autorisation est 
```shell
"Basic QVMyalNhREdVeGFPRThWY3FEalJBQ0NJWk0zaFR0eHU6cENtallQTkd2QUdXT0hGOQ=="
```
pour la suite nous allons supposer que cette en tête est sauvegardée dans la variable *AUTH_TOKEN*
# étapes pour configurer l'API Orange d'envoie de sms

## Recevoir le token d'accès
Définir un e fonction qui permet de récupérer le token
```python
def get_access_token():
    """
    Query Orange API with application details to obtain an authentication token
    
    Returns:
        dict: dictionary containing the status code of the response and response data
    """
    url = 'https://api.orange.com/oauth/v3/token'
    headers = {
        'Authorization': AUTH_TOKEN,
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json'
    }
    data = {
        'grant_type': 'client_credentials'
    }
    resp = requests.post(url, data=data, headers=headers)
    return {
        "status": resp.status_code,
        "response" : resp.json()
    }
```

comme retour on aura 
```json
HTTP/1.1 200 OK
Content-Type: application/json
{
    "token_type": "Bearer",
    "access_token": "{{access_token}}",
    "expires_in": "3600"
}
```

Le token d'accès  a une durée de vie de 3600 secondes, soit 1 heure. Donc vous n'avez pas besoin d'en redemander un nouveau avant chaque envoi de SMS. Il vous suffit de bien gérer les erreurs potentielles dans vos futurs appels, notamment pour détecter l'erreur de type out-of-date comme ci-dessous :

```json
HTTP/1.1 401 Unauthorized
Content-Type: application/json
{
  "code": 42,
  "message": "Expired credentials",
  "description": "The requested service needs credentials, and the ones provided were out-of-date."
}
```
Dans ce cas, il vous suffit de redemander un nouveau token. 

## L'envoie de sms
En supposant que vous avez déclaré votre application, que vous avez souscrit à la ou les API SMS souhaitées et que vous avez acheté votre bundle, vous pouvez maintenant commencer à envoyer des SMS à vos clients. Voici les informations techniques dont vous aurez besoin :
Token url : [](https://api.orange.com/oauth/v3/token) Messaging base-url : [](https://api.orange.com/smsmessaging/v1) Contract management base-url : [](https://api.orange.com/sms/admin/v1)

la fonction pour envoyer le sms est :
```python

def send_message(receiver_phone, message, auth, sender_phone=SENDER_PHONE):
    """This function sends an SMS message to a given phone number

    Args:
        receiver_phone (str): receiver phone number in international format
        message (str): Message to be sent(should be maximum 160 characters)
        auth (str): authentication header value
        sender_phone (str, optional): Sender phone number. Should only come from api. Defaults to SENDER_PHONE.

    Returns:
        dict: Dictionary of return status code and response data from orange api
    """
    url = f'https://api.orange.com/smsmessaging/v1/outbound/tel%3A%2B{sender_phone}/requests'
    headers = {
        "Content-Type" : "application/json",
        "Accept": 'application/json',
        "Authorization": auth
    }
    data = {
        "outboundSMSMessageRequest": {
            "address" : "tel:+" + receiver_phone,
            "senderAddress": "tel:+" + sender_phone,
            "outboundSMSTextMessage": {
                "message" : message
            }
        }
    }
    r = requests.post(url=url, data=json.dumps(data), headers=headers)
    return {
        "status": r.status_code,
        "content": r.json()
    }
```

# Utilisation

## Modèle pour sauvegarder le token
```python

AVAILABLE_APIS = [
    ('ORANGE', 'ORANGE')
]

API_TYPES = [
    ('SMS', 'SMS'),
    ('EMAIL', 'EMAIL')
]

MESSAGE_TYPES = [
    'VERIFICATION', 
    'NOTIFICATION'
]
# Create your models here.
class APIToken(models.Model):
    api_type = models.CharField(choices=API_TYPES, max_length=50)
    api = models.CharField(choices=AVAILABLE_APIS, max_length=50)
    token_type = models.CharField(max_length=100)
    access_token = models.TextField()
    expires_at = models.DateTimeField(default=timezone.now)
    
    class Meta:
        unique_together = (('api_type', 'api'),)
    
    def get_auth(self):
        return self.token_type + " " + self.access_token

```

## Préparer le message à envoyer
```python

class SMSMessage:
    """
    This class represents a prepare message that can be sent with a selected API. 
    """
    def __init__(self, receiver: str, message: dict or str, type='VERIFICATION', lang='en'):
        if receiver.startswith('+'):
            receiver = receiver[1:]
        self.receiver = receiver
        template = ''
        if type =='VERIFICATION':
            if lang == 'en':
                template = verification_message_en
            else:
                template = verification_message_fr
            self.message = template.format(
                greeting = message['greeting'],
                code = message['code'],
                signature = message['signature']
            )
        else:
            self.message = message
        self.lang = lang
    
    def send_message(self, api='ORANGE'):
        """
        Trigger the actual sending of the sms. 
        
        Chooses the right functions to call depending on the chosen sms api
        then calls the appropriate functions as relates to the requested API
        """
        token = APIToken()
        try:
            token = APIToken.objects.filter(api_type='sms', api=api).get()
            if token.expires_at < timezone.now():
                token.delete()
                raise ObjectDoesNotExist()
        except ObjectDoesNotExist:
            resp = get_access_token()
            if resp['status'] == 200:
                token = APIToken(
                    api_type = 'sms',
                    api=api,
                    token_type = resp['response']['token_type'],
                    access_token = resp['response']['access_token'],
                    expires_at = timezone.now() + timezone.timedelta(seconds=resp['response']['expires_in'])
                )
                token.save()
            else:
                raise Exception("Unable to obtain token")
        return send_message(
            self.receiver,
            self.message,
            token.get_auth()
        )
```

## gestion de l'envoi des messages de vérification.

```python

class SMSVerification:
    """
    This class handles the sending of verification messages. 
    
    :param receiver The number to which the message is to be sent
    :param code The code that is to be sent to the intended recipient
    :param lang Language in which the message is to be sent
    """
    def __init__(self, receiver: str, code: str, lang='en'):
        message = dict()
        if lang == 'en':
            message['greeting'] = greeting_en
        else:
            message['greeting'] = greeting_fr
        message['code'] = code
        message['signature'] = signature
        self.sms_message = SMSMessage(receiver=receiver, message=message, type='VERIFICATION', lang=lang)

    def send_message(self, api='ORANGE'):
        return self.sms_message.send_message(api=api)
```

## Dans une vue python on peut utiliser ces fonctions ainsi

```python
    message = SMSVerification(
            receiver=phone_number,
            code=code,
            lang='en'
        )
        resp = message.send_message()
        if resp['status'] != 201:
            return Response("Error sending verification message", status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        else: 
           return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
        
```
