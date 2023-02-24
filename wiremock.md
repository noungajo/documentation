# readme de wiremock

Wiremock est un outil pour simuler le backend presque du même style que Json server. On crée la requête et la valeur de retour et on peut tester commme s'il y avait un réel API qui répondait. L'intérêt est qu'une fois configuré on peut continuer le dev en l'absence de connection avec l'API ou pour une quelconque défaillance de celui-ci.

[Documentation officiel](#https://wiremock.org/docs/running-standalone/)

## lancer wiremock

```shell
java -jar wiremock-jre8-standalone-2.33.2.jar
```

l'adresse est le localhost:8080

> On crée un nouveau mapping

```json
{
    "request": {
        "method": "GET",
        "url": "/api/v2/shop/taxons"
    },
    "response": {
        "status": 200,
        "jsonBody": {"key":"value"},
        "headers": {
            "Content-Type": "application/json"
        }
    }
}
```

l'url concerne celui du n point à complèter sur l'adresse de lancement de wiremock

## Test

pour tester on se rend sur postman ou un consommateur d'API et on lance l'adresse selon le format : adress/n point

```
localhost:8080/api/v2/shop/taxons
```