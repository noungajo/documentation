# JWT Authentication — Django Rest Framework

JSON Web Token (JWT) est une norme ouverte qui définit un moyen compact et autonome de transmettre de manière sécurisée des informations entre les parties sous la forme d'un objet JSON. Ces informations peuvent être vérifiées et fiables car elles sont signées numériquement. JWT est utilisé pour créer des jetons d'accès pour une application. JWT est utilie pour l'authentification API et l'autorisation de serveurs à serveur. Le serveur génère un jeton qui certifie l'identité de l'utilisateur et l'envoie au client. Le client renverra le jeton au serveur pour chaque demande ultérieure, afin que le serveur sache que la demande provient d'une identité particulière.

![](jwt.png)

Dns sa forme compacte, le jeton Web Json se compose de trois parties séparées par des points, qui sont l'en-tête, la charge utile et la signature.
En-tête(header): identifie quel algorithme est utilisé pour générer la signature.
La charge utile (Payload): Contient un ensemble de revendications. Les revendications sont des déclarations concernant une entité.
Signature: valide de manière sécurisée le jeton. 

premièrement nous aurons besoin d'installer le paquet django-rest-framework-simplejwt

```shell
pip install djangorestframework-simplejwt
```

Après l'installation, nous devons explicitement dire à DRF quel système d'authentification nous allons utiliser. Dans le fichier **setting.py** et créer une nouvelle clé dans **REST_FRAMEWORK**

```python
REST_FRAMEWORK = {
    'DEFAULT_FILTER_BACKENDS': [
        'django_filters.rest_framework.DjangoFilterBackend'
    ],
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ],
}
```

## IsAuthenticated

la première permission étudiée est celle de donner accès aux utilisateur authentifiés à une vue (ici la vue est dans le fichier views.py).

```python
from rest_framework.permissions import IsAuthenticated

def all_image(request):
    ...
    permission_classes = [IsAuthenticated]
```

Cette simple permission donne accès à la vu *all_image(request)* uniquement aux utilisateur authentifié.
Lorsqu'un internaute non authentifié voudrait avoir accès à une vue qui a des droits d'accès voici ce que renvoie la vue

![](is_notauth_permission.png)

Pour obtenir un token nous devons envoyer une requête **POST** à l'API. Le corps de la requête doit avoir deux parties: **username** et **password**
Pour cela il faut définir la vue de login. pour le faire il faut:
aller dans le fichier *urls.py* de l'application et intégrer le code suivant

```json
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
# puis ajouter les chemins suivant:
urlpatterns = [
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('login/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

]
```

vous effectuez un post sur le login, selon l'url que vous aurez définit. Pour le test je l'ai fait sur rest_framework car sur postaman il me retourne du code html. pour le lire il faut le mettre dans un fichier .html et l'ouvrir avec un navigateur pour avoir le résulat. Et il ressemblera à ceci:

![](get_token.png)

Pour avoir accès à la vue protégée il faut inclure à l'en-tête de la requête le token d'accès ainsi:
Lorsque vous faites le **POST** sur le login la réponse est:

```JSON
{
    "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTYzODQ3MDI4MywiaWF0IjoxNjM4MzgzODgzLCJqdGkiOiJjMmNjNjkyZmVkMzA0YTE5ODM3NThhZTRhNmFmMjhlMiIsInVzZXJfaWQiOjJ9.MWU8FlFF5aReehS3NRDpNf2chznuWpDGYrqpk2IJfKA",
    "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjM4Mzg0MTgzLCJpYXQiOjE2MzgzODM4ODMsImp0aSI6ImUwOTQ0NWY4OGRjNDRhYjVhZjRmZTljMGVjMTg0ZmZjIiwidXNlcl9pZCI6Mn0.fTIIUQCj6ZW5214cVfvyTvXoeySaa4BgAeshwdFFPck"
}
```

On copie la valeur dont la clé est "access" et on colle sur la méthode **GET** en spécifiant le type d'authorization "Bearer Token" et sur le token ajouter la valeur de "access". Le résulat est ainsi

![](get_auth.png)

Après 5 minutes le token va expirer. Si l'on essaye d'accéder à la vue protégée, on aura l'erreur suivante:

![](token_expire.png)

Pour avoir un nouveau token, nous devons effectuer un loginrefresh avec le token "refresh". Comme retour nous avons un nouveau token d'accès est généré:

![](refresh.png)

et on peut l'utiliser comme précédemment pour de nouveau avoir accès à la vue protégée.

Par défaut un token valide  a une durée de 5 min. Pour avoir de nouveau à la vue portégée il faut utiliser un token refresh qui a une validité de 24h. Lorsqu'il expire une nouvelle authentification est demandée(l'entrée du username et du password).
Nous pouvons changer la durée de vie des tokens refresh à 15 jours. Et nous pouvons faire tourner les tokens refresh pour que les utilisateurs n'aient pas à se reconnecter s'ils visitent le site dans les 15 jours. Pour cela il suffit d'ajouter au fichier setting.py le code suivant:

```python
from datetime import timedelta

SIMPLE_JWT = {
    'REFRESH_TOKEN_LIFETIME': timedelta(days=15),
    'ROTATE_REFRESH_TOKENS': True,
}
```