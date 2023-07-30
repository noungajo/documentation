
# Documentation de Django Knox

## Introduction

Django Knox est un package d'authentification pour Django qui offre des fonctionnalités avancées pour la gestion des tokens d'authentification. Il est conçu pour être utilisé avec Django REST Framework (DRF) et offre une alternative sécurisée et flexible à l'authentification par tokens.

## Fonctionnalités

Les principales fonctionnalités offertes par Django Knox sont les suivantes :

1. Génération de tokens d'authentification : Knox génère des tokens d'authentification uniques pour les utilisateurs authentifiés. Ces tokens sont utilisés pour vérifier l'identité de l'utilisateur lorsqu'il accède aux API protégées.

2. Validité et expiration des tokens : Les tokens générés par Knox sont automatiquement associés à une date d'expiration, ce qui garantit que les tokens sont valides pendant une durée limitée. Une fois qu'un token a expiré, il n'est plus valide pour l'authentification.

3. Renouvellement automatique des tokens : Knox offre la possibilité de renouveler automatiquement les tokens expirés, ce qui permet aux utilisateurs de rester connectés sans avoir à se reconnecter manuellement à chaque fois que leur token expire.

4. Limitation du nombre de tokens actifs par utilisateur : Knox permet de limiter le nombre de tokens actifs qu'un utilisateur peut avoir à la fois, ce qui ajoute une couche de sécurité supplémentaire en cas de vol de token.

## Utilisation

Pour utiliser Django Knox dans votre application Django avec Django REST Framework, suivez ces étapes :

1. Installation : Installez le package Django Knox en utilisant `pip` :

```bash
pip install django-rest-knox
```

2. Configuration : Ajoutez `'knox'` à la liste `INSTALLED_APPS` dans votre fichier `settings.py` :

```python
INSTALLED_APPS = [
    # ...
    'knox',
    # ...
]
```

3. Création d'un token pour l'utilisateur : Pour générer un token pour un utilisateur, utilisez la méthode `knox.models.AuthToken.objects.create(user)`. Par exemple :

```python
from knox.models import AuthToken

# Supposons que 'user' est l'objet User pour lequel nous voulons générer un token
token = AuthToken.objects.create(user)
```

4. Utilisation du token pour l'authentification : Lorsqu'un utilisateur souhaite accéder à une API protégée, il doit inclure son token dans l'en-tête d'autorisation HTTP. L'en-tête doit avoir la valeur `'Token ' + token.key`. Voici un exemple avec la bibliothèque `requests` en Python :

```python
import requests

# Supposons que 'token' est le token d'authentification généré précédemment
headers = {'Authorization': f'Token {token.key}'}

# Supposons que 'url' est l'URL de l'API protégée
response = requests.get(url, headers=headers)

# La réponse contient les données de l'API
print(response.json())
```

5. Renouvellement automatique du token : Si vous souhaitez activer le renouvellement automatique du token expiré, vous pouvez le faire en configurant la variable `AUTO_REFRESH` dans les paramètres `REST_KNOX` de votre fichier `settings.py`. Par exemple :

```python
REST_KNOX = {
  # ...
  'AUTO_REFRESH': True,
  # ...
}
```

Avec cette configuration, lorsqu'un token expire, si l'utilisateur envoie une requête avec le token expiré, Knox renouvellera automatiquement le token et enverra le nouveau token dans la réponse. L'utilisateur n'aura pas besoin de se reconnecter manuellement.
La documentation officielle de Django Knox pour plus de détails et de fonctionnalités avancées : https://james1345.github.io/django-rest-knox/.
