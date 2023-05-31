#!/bin/bash 


firstname=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 10 ; echo '')

echo $firstname 


userToken=""
cmdToken=""
echo "Start test of cart creattion and order completion"
function CreateAccont() {
curl -X 'POST' \
  'http://163.172.48.36:8081/api/v2/shop/customers' \
  -H 'accept: */*' \
  -H 'Content-Type: application/ld+json' \
  -d "{
  \"firstName\": \"$firstname\",
  \"lastName\": \"kamga\",
  \"email\": \"$firstname.kamga@gmail.com\",
  \"password\": \"firmin\",
  \"subscribedToNewsletter\": true
}" | jq 
}

function AuthenticateUser () {

echo "1. User registration"
echo 

curl -X 'POST' \
  'http://163.172.48.36:8081/api/v2/shop/authentication-token' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "{
  \"email\": \"$firstname.kamga@gmail.com\",
  \"password\": \"firmin\"
}" | jq '.token' > token 

userToken=$(cat ./token | sed 's/"//g')

echo "User Token is $userToken"
echo 
}

# création de la commande
function Order(){
echo "Pick up a new cart $userToken"
echo 

curl -X 'POST' \
  'http://163.172.48.36:8081/api/v2/shop/orders' \
  -H 'accept: application/ld+json' \
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

function OrderA(){
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

function DeleteOrder(){
# Supprimer la commande
echo "clear older/pending command"
echo 
curl -X 'DELETE' \
  "http://163.172.48.36:8081/api/v2/shop/orders/$cmdToken" \
  -H 'accept: */*' | jq

} 

function NewItem(){
# ajout d'un produit à la commande
echo "Addinnew product variant : 00010anglais"
echo 

curl -X 'POST' \
  "http://163.172.48.36:8081/api/v2/shop/orders/$cmdToken/items" \
  -H 'accept: application/ld+json' \
  -H 'Content-Type: application/ld+json' \
  -d '{
  "productVariant": "/api/v2/shop/product-variants/00010anglais",
  "quantity": 2
}' | jq 
}

function NewItemA(){
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


# ajout de l'adresse de facturation
function BillingAddress(){
echo "Adding billing Address for user Nana "
echo 

curl -X 'PUT' \
  "http://163.172.48.36:8081/api/v2/shop/orders/$cmdToken" \
  -H 'accept: application/ld+json' \
  -H 'Content-Type: application/ld+json' \
  -d '{
  "email": "nana@gmail.com",
  "billingAddress": {
  "firstName": "Nana", 
    "lastName": "fabrice", 
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

function BillingAddressA(){
echo "Adding billing Address for user Nana "
echo 

curl -X 'PUT' \
  "http://163.172.48.36:8081/api/v2/shop/orders/$cmdToken" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $userToken" \
  -H 'Content-Type: application/ld+json' \
  -d '{
  "email": "nana@gmail.com",
  "billingAddress": {
  "firstName": "Nana", 
    "lastName": "fabrice", 
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
function SelectPaymentMethod(){
set -x 
paymentId=$(cat ./cart | jq '.payments[0].id')
paymentMethod=$(cat ./cart | jq '.payments[0].method' | sed -e 's/"//g')


# choisir la méthode de paiement
echo "****************** selecting paymementnpayment $paymentMethod  $paymentId********"
echo 
curl -X 'PATCH' \
  "http://163.172.48.36:8081/api/v2/shop/orders/$cmdToken/payments/$paymentId" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $userToken" \
  -H 'Content-Type: application/merge-patch+json' \
  -d "{
  \"paymentMethod\": \"$paymentMethod\"
}" | jq 
set +x
}
# choisir la methode de livraison


function SelectShippingMethod(){
	set -x
shipmentId=$(cat ./cart | jq '.shipments[0].id')
shippingMethod=$(cat ./cart | jq '.shipments[0].method' | sed -e 's/"//g')
echo  "slecting shipment method $shippingMethod  "
echo 
curl -X 'PATCH' \
  "http://163.172.48.36:8081/api/v2/shop/orders/$cmdToken/shipments/$shipmentId" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $userToken" \
  -H 'Content-Type: application/merge-patch+json' \
  -d "{
  \"shippingMethod\": \"$shippingMethod\"
}" | jq 
set +x
}

# 
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


Order
NewItem
#BillingAddress

CreateAccont
AuthenticateUser
#clonnage
OrderA
NewItemA
BillingAddressA

SelectShippingMethod
SelectPaymentMethod

CompletOrder
echo "End of test"

exit 
