# Tester une API utilisant du code python

**pytest est un framework qui facilite la création de tests simples et évolutifs. Les tests sont expressifs et lisibles - aucun code passe-partout n'est nécessaire. Commencez en quelques minutes avec un petit test unitaire ou un test fonctionnel complexe pour votre application ou votre bibliothèque.** 
  
## Installation de pytest

En ligne de commande entrez la commande:

```shell
>pip install -U pytest
```

vérifier que la version correcte a été installée

```shell
pytest --version
pytest 6.2.5
```

## Création de notre premier test

Nous allons supposé que le sérialiseur fonctionne déjà et que l'interface de rest-framework(ou postman) permet déjà la consommation de l'API. Nous allons nous focaliser sur la partie test. Entrez dans votre application et vous verrez un fichier *test*.*py*. Ajoutez le code suivant:

```python
import requests

# url de l'API
url = "http://127.0.0.1:8000/userpost/"

def test_get_user():
    #réaliser une requête POST avec le contenu du fichier json d'entré
    response = requests.get(url)
    #validation du code de la réponse. Le status_code de tout s'est bien passé est 200
    assert response.status_code == 200

def test_post_user():
    #lecture du fichier json d'entré
    file = open("fichier.json","r")
    json_input = file.read()
    request_json = json.loads(json_input)
    #réaliser une requête POST avec le contenu du fichier json d'entré
    response = requests.post(url,request_json)
    #validation du code de la réponse
    assert response.status_code == 201
```

> Dans ce fichier nous avons définie une fonction qui permet d'affciher les utilisateurs, il est à noter que la fonction doit débuter par le mot clé *test*. L'url est celui définit dans le fichier *urls\.py* de notre application.
> Nous observons aussi que la fontion post ne fonctionne pas *assert* n'est pas vérifié.

Depuis le repertoire où se trouve le fichier *tests\.py*, ouvrir le terminal et exécuter la commande

```shell
pytest -v tests.py
```

où l'option *-v* permet d'avoir plus de précision. Ci-dessous la capture d'écran du résultat.

<img src="capture.PNG">

Contenu du *fichier.json*

```json
{
    "id": 1,
    "username": "admin",
    "first_name": "Noutcha",
    "last_name": "Jonathan",
    "email": "admin@admin.com",
    "profile": {
        "date_naissance": "2021-10-25",
        "couleur_voiture": "",
        "marque_voiture": "",
        "image": "/media/minefop-300x300.jpg"
    }
}
```

> NOUTCHA NGAPI Jonathan