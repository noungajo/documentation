
#!/bin/bash

#Send reset password
function reset_password(){
curl -X 'POST' \
  'http://93.28.23.252:8080/api/v2/shop/reset-password-requests' \
  -H 'accept: */*' \
  -H 'Content-Type: application/ld+json' \
  -d '{
  "email": "819df3@gmail.com",
  "locale": "fr"
}'

}

#Login user


echo LOGIN_USER

user="prodoffanoibe-2486@yopmail.com"

token=$(curl -s -X 'POST' \
  'http://93.28.23.252:8080/api/v2/shop/authentication-token' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "email": "prodoffanoibe-2486@yopmail.com",
  "password": "Toto123456"
}' | jq ".token" | sed 's/"//g' )

#echo $token

function listAddressOfUser(){
echo LIST USER ADDRESSES

curl -s -X 'GET' \
  'http://93.28.23.252:8080/api/v2/shop/addresses?page=1&itemsPerPage=30' \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" | jq . > /dev/null

curl -s -X 'PUT' \
  'http://93.28.23.252:8080/api/v2/shop/addresses/1296' \
  -H 'accept: application/ld+json' \
  -H 'Content-Type: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -d '{
    "firstName": "test",
    "lastName": "test",
    "phoneNumber": "334509484",
    "company": "string",
    "countryCode": "CM",
    "provinceCode": "CM-LT",
    "provinceName": "Douala",
    "street": "douala",
    "city": "Douala",
    "postcode": "123"
}' > /dev/null

}
listAddressOfUser

# Choose article
#

echo CHOOSE ARTICLE
curl -s -X 'GET' \
  'http://93.28.23.252:8080/api/v2/shop/product-variants?page=1&itemsPerPage=30' \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" | jq . > /dev/null



variant="/api/v2/shop/product-variants/00011allemand"

#Pick cart

echo PICKUP CART

cmdToken=$(curl -s -X 'POST' \
  'http://93.28.23.252:8080/api/v2/shop/orders' \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/ld+json' \
  -d '{}' | jq ".tokenValue" | sed 's/"//g')

echo $cmdToken


# Add item to cart
#
echo ADDD ITEM TO CART

curl -s -X 'POST' \
  "http://93.28.23.252:8080/api/v2/shop/orders/$cmdToken/items" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/ld+json' \
  -d "{
  \"productVariant\": \"$variant\",
  \"quantity\": 1
}
" | jq . > order.json


echo AVAILABLE SHIPPEMENT
jq '.shipments[].method' order.json


echo AVAILABLE PAYMENT

jq '.payments[].method' order.json



echo ALL COUNTRIES

curl -s -X 'GET' \
  'http://93.28.23.252:8080/api/v2/shop/countries?page=1&itemsPerPage=30' \
  -H 'accept: application/ld+json' |  jq '.["hydra:member"][0] | "Country: "+ .name + ", Code: " + .code '


#Address order

echo  ADDRESS COMMAND

curl -s -X 'PUT' \
  "http://93.28.23.252:8080/api/v2/shop/orders/$cmdToken" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/ld+json' \
  -d '{
  "email": "prodoffanoibe-2486@yopmail.com",
  "billingAddress": {

    "firstName": "test",
    "lastName": "test",
    "phoneNumber": "334509484",
    "company": "string",
    "countryCode": "CM",
    "provinceCode": "CM-LT",
    "provinceName": "Douala",
    "street": "douala",
    "city": "Douala",
    "postcode": "123"
  },
  "shippingAddress": {
    "firstName": "test",
    "lastName": "test",
    "phoneNumber": "334509484",
    "company": "string",
    "countryCode": "CM",
    "provinceCode": "CM-CE",
    "provinceName": "Yaoundé",
    "street": "dfpdpfodpof ",
    "city": "Yaoundé",
    "postcode": "123"
  }
}' | jq '.'   > ./order.json

echo AVAILABLE SHIPPEMENTS METHODS

method=$(jq '.shipments[].method' order.json |  sed -e 's/"//g' | cut -d '/' -f 6)

echo $method


shipId=$(jq ".shipments[].id" order.json)
payId=$(jq ".payments[].id" order.json)


echo "****************"
echo
echo $shipId
echo
echo $payId
echo "********************"
echo



# Select ship method
#
echo SELET SHIP METHOD

curl -s -X 'PATCH' \
  "http://93.28.23.252:8080/api/v2/shop/orders/$cmdToken/shipments/$shipId" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/merge-patch+json' \
  -H 'Accept-Language: fr' \
  -d "{
  \"shippingMethod\": \"$method\"
}" | jq . > /dev/null


# Select payment

echo SELET PAYMENT

curl -s -X 'PATCH' \
  "http://93.28.23.252:8080/api/v2/shop/orders/$cmdToken/payments/$payId" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/merge-patch+json' \
  -d '{
  "paymentMethod": "mtn_momo"
}
' | jq .


# Complete
curl -X 'PATCH' \
  "http://93.28.23.252:8080/api/v2/shop/orders/$cmdToken/complete" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/merge-patch+json' \
  -d '{
        "notes": "merci de livrer a mon domicile"
    }
' | jq .

echo $cmdToken
echo ======================PAY================================

curl -v -X 'GET' -L  \
  "http://93.28.23.252:8080/fr/order/$cmdToken/pay" \
  -H "Authorization: Bearer $token"
