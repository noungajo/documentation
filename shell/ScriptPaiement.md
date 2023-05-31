# Scripts du processus de paiement

Cette documention présente le processus complet de paiement. Son contenu peut être utilisé pour requêter de manière automatique des endapoints d'une API. Cela est utile dans le sens où ça permet de gagner en temps lorsqu'il y'a des multiples exécutions à faire.

Il faut prendre en compte les éléments suivants:
- Notre API pour l'instant ne supporte pas les utilisateurs anonymés
- Donc iln'est pas possible pour l'instant de finaliser une commande sans être un utilisateur connecté.

## Connexion

En supposant qu'il s'agit d'un utilisateur qui possède déjà un compte, il peut utiliser un endpoint pour se connecter :

```shell
#!/bin/bash 

userToken=""
cmdToken=""

echo "Start test of cart creation and order completion"

function UserRegistration () {

echo "1. User registration"
echo 

curl -X 'POST' \
  'http://163.172.48.36:8081/api/v2/shop/authentication-token' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "email": "nana@gmail.com",
  "password": "nana"
}' | jq '.token' > token 

userToken=$(cat ./token | sed 's/"//g')

echo "User Token is $userToken"
echo 
}
```

> Ici est sauvegardé le token qui permet d'authentifier l'utilisateur dans la variable *$userToken*

## Création de la commande

Une fois connecter l'utilisateur peut créer sa commande via la requête curl ci-dessous : 

```shell
function Order(){
echo "Pick up a new cart $userToken"
echo 

curl -X 'POST' \
  'http://163.172.48.36:8081/api/v2/shop/orders' \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $userToken" \
  -H 'Content-Type: application/ld+json' \
  -d '{
  "localeCode": "fr"
}' -o newCart 

cat ./newCart | jq 

cat ./newCart | jq '.tokenValue' | sed -e 's/"//g' > token 

cmdToken=$(cat ./token)

echo "Order token is $cmdToken"
echo 
}
```

> Le token de la commande est sauvegarder dans la variable *$cmdToken*
## Ajouter un item à la commande

Maintenant il faut ajouter un item à la commande

```shell
function NewItem(){
# ajout d'un produit à la commande
echo "Addinnew product variant : 00010anglais"
echo 

curl -X 'POST' \
  "http://163.172.48.36:8081/api/v2/shop/orders/$cmdToken/items" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $userToken" \
  -H 'Content-Type: application/ld+json' \
  -d '{
  "productVariant": "/api/v2/shop/product-variants/00010anglais",
  "quantity": 2
}' | jq 
}
```

## Adresse de facturation & adresse de livraison

Nous allons supposer que l'utilisateur utilise une adresse pour la facturation et la livraison. Ainsi nous n'allons ajouter que l'adresse de facturation.
```shell
# ajout de l'adresse de facturation
function BillingAddress(){
echo "Adding billing Address for user Nana "
echo 

curl -X 'PUT' \
  "http://163.172.48.36:8081/api/v2/shop/orders/$cmdToken" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $userToken" \
  -H 'Content-Type: application/ld+json' \
  -d '{
  "email": "jonas.kamga@gmail.com",
  "billingAddress": {
  "firstName": "jonas", 
    "lastName": "kamga", 
    "countryCode": "CM", 
    "provinceCode": "CM-CE", 
    "provinceName": "CENTRE", 
    "street": "Carrefour Jouvence", 
    "city": "Yaoundé", 
    "postcode": "Bastos"
  }
}' | jq > cart 

cat cart | jq  
}
```

Cette requête retourne le panier avec les adresses de livraison et de facturation. cela est redirigé dans la variable cart

## Sélectionner la méthode de paiement

La méthode de paiement s'extrait de la variable cart.

```shell
function SelectPaymentMethod(){
paymentId=$(cat ./cart | jq '.payments[0].id')
paymentMethod=$(cat ./cart | jq '.payments[0].method' | sed -e 's/"//g')


# choisir la méthode de paiement
echo "****************** selecting paymementnpayment $paymentMethod ********"
echo 
curl -X 'PATCH' \
  "http://163.172.48.36:8081/api/v2/shop/orders/$cmdToken/payments/$paymentId" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $userToken" \
  -H 'Content-Type: application/merge-patch+json' \
  -d "{
  \"paymentMethod\": \"$paymentMethod\"
}" | jq 
}
```

## Sélectionner la méthode de livraison

La méthode de livraison s'extrait de la variable cart

```shell
# choisir la methode de livraison


function SelectShippingMethod(){
shipmentId=$(cat ./cart | jq '.shipments[0].id')
shippingMethod=$(cat ./cart | jq '.shipments[0].method' | sed -e 's/"//g')
echo  "slecting shipment method $shippingMethod"
echo 
curl -X 'PATCH' \
  "http://163.172.48.36:8081/api/v2/shop/orders/$cmdToken/shipments/$shipmentId" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $userToken" \
  -H 'Content-Type: application/merge-patch+json' \
  -d "{
  \"shippingMethod\": \"$shippingMethod\"
}" | jq 
}
```

## Finaliser la commande

Finaliser la commande se fait via la requête :

```shell
# finaliser la commande
function CompletOrder(){
echo  "complet the order $cmdToken for user nana"

curl -X 'PATCH' \
  "http://163.172.48.36:8081/api/v2/shop/orders/$cmdToken/complete" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $userToken" \
  -H 'Content-Type: application/merge-patch+json' \
  -d '{
  "notes": "je suis le meilleur"
}' | jq 
echo 
}
```
## Ordre d'appelation des fonctions

l'ordre d'appelation des fonctions est :

- UserRegistration
- Order
- NewItem
- BillingAddress
- SelectShippingMethod
- SelectPaymentMethod
- CompletOrder
  
echo "End of test"
