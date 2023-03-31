# Requete simplifié pour l'envoie de sms
## requête pour avoir le token access
 pour le faire il faut avoir le token d'authorisation fourni sur la plateforme orange.
 
 - Notre autorisation
 
 ```shell
 Basic cWVqSW1BRDRndTFlbzh1anBFZ3RnQ2FpMVpkV0VReWo6YVZjU3ZwRWxlSHpmdEFhSw==
 ```
 nous allons l'appeler **authorization_header** pour la suite
 
 - Requête curl pour avoir le token d'autorisation
 
 ```shell
 curl -X POST 
 -H "Authorization: authorization_header" 
 -H "Content-Type: application/x-www-form-urlencoded" 
 -H "Accept: application/json" 
 -d "grant_type=client_credentials" 
 https://api.orange.com/oauth/v3/token

 ```
 
 retour
  
 ```shell
	 HTTP/1.1 200 OK
	Content-Type: application/json
	 {
	  "token_type": "Bearer",
	  "access_token": "eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJKV1QiLCJhbGciOiJFUzM4NCIsImtpZCI6ImRzRUN2TDVaTENQbTl1R081RHltUjZCRTdMcnFGak5hX1VKbl9Ody1zdVUifQ.eyJhcHBfbmFtZSI6IkFuZGFhbCIsInN1YiI6InFlakltQUQ0Z3UxZW84dWpwRWd0Z0NhaTFaZFdFUXlqIiwiaXNzIjoiaHR0cHM6XC9cL2FwaS5vcmFuZ2UuY29tXC9vYXV0aFwvdjMiLCJleHAiOjE2Nzg5NjgxODIsImFwcF9pZCI6IlFickQ5ajVUUHZXbVJNVjciLCJpYXQiOjE2Nzg5NjQ1ODIsImNsaWVudF9pZCI6InFlakltQUQ0Z3UxZW84dWpwRWd0Z0NhaTFaZFdFUXlqIiwianRpIjoiNmQwNDI2ZDctZTI2ZC00NWJkLWEyNDEtYjJhZTAyYTVhMjFjIn0.AbOtqph7e0vnYbNrYTfnNSWr9Z2fJJe3uhfttfNI2iRxYgYU3tgRIaGg8v-RGY63LkgQRtVFKPA7HMBRhWehzvggZy3ZC4gmFIFww0NuGkPEuW_8m3H0xMSxHGvZewRJ",
	  "expires_in": 3600
	}
```

L'accès token peut être récupéré pour compléter l'en tête pour envoyer le sms

 - Requête curl pour envoyer le sms
 Dénotons les points suivants:
 	- access_token :  le token recu lors de la requête précédante
 	- recipient_phone_number : le numéro de celui qui va recevoir le sms de la forme 237600000000
 	- dev_phone_number : le numéro du celui qui envoie le sms. Notre numéro est 237696872408
 	- message :  le message à envoyer à l'utilisateur
 
 ```shell
	 curl -X POST -H "Authorization: Bearer access_token" \
	-H "Content-Type: application/json" \
	-d '{"outboundSMSMessageRequest":{ \
		"address": "tel:+recipient_phone_number", \
		"senderAddress":"tel:+dev_phone_number", \
		"outboundSMSTextMessage":{ \
		    "message": message \
		} \
	    } \
	}' \
	"https://api.orange.com/smsmessaging/v1/outbound/tel%3A%2B{{dev_phone_number}}/requests"
```

Le retour est

```shell
	{
	    "outboundSMSMessageRequest": {
		"address": [
		    "tel:+recipient_phone_number"
		],
		"senderAddress": "tel:+dev_phone_number",
		"outboundSMSTextMessage": {
		    "message": message
		},
		"resourceURL": "https://api.orange.com/smsmessaging/v1/outbound/tel:+237696872408/requests/487d897d-093c-4588-916a-78dd6bb542ec"
	    }
	}
```

