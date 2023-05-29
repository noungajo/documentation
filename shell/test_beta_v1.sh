
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

token=$(curl -X 'POST' \
  'http://93.28.23.252:8080/api/v2/shop/authentication-token' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "email": "cowoiraunnofro-4202@yopmail.com",
  "password": "5ybjhGTXUQgp3xD"
}' | jq ".token" | sed 's/"//g' )

echo $token

# Choose article
#

curl -X 'GET' \
  'http://93.28.23.252:8080/api/v2/shop/product-variants?page=1&itemsPerPage=30' \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" | jq .



variant="/api/v2/shop/product-variants/00012allemand"

#Pick cart

cmdToken=$(curl -X 'POST' \
  'http://93.28.23.252:8080/api/v2/shop/orders' \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/ld+json' \
  -d '{}' | jq ".tokenValue" | sed 's/"//g')


echo $cmdToken


# Add item to cart

curl -X 'POST' \
  "http://93.28.23.252:8080/api/v2/shop/orders/$cmdToken/items" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/ld+json' \
  -d "{
  \"productVariant\": \"$variant\",
  \"quantity\": 1
}
" | jq . > order.json

#Address order

curl -X 'PUT' \
  "http://93.28.23.252:8080/api/v2/shop/orders/$cmdToken" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/ld+json' \
  -d '{
  "email": "cowoiraunnofro-4202@yopmail.com",
  "billingAddress": {

    "firstName": "test",
    "lastName": "test",
    "phoneNumber": "334509484",
    "company": "string",
    "countryCode": "CM",
    "provinceCode": "CM-CE",
    "provinceName": "Centre",
    "street": "yaoundé",
    "city": "yaoundé",
    "postcode": "123"
  },
  "shippingAddress": {
    "firstName": "test",
    "lastName": "test",
    "phoneNumber": "334509484",
    "company": "string",
    "countryCode": "CM",
    "provinceCode": "CM-LT",
    "provinceName": "Littoral",
    "street": "dfpdpfodpof ",
    "city": "Douala",
    "postcode": "123"
  }
}'


shipId=$(jq ".shipments[].id" order.json)
payId=$(jq ".payments[].id" order.json)

echo "****************"
echo
echo $shipId
echo
echo $payId
echo "********************"
echo


exit 
# Select ship method

curl -X 'PATCH' \
  "http://93.28.23.252:8080/api/v2/shop/orders/$cmdToken/shipments/$shipId" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/merge-patch+json' \
  -d '{
  "shippingMethod": ""
}' | jq .


# Select payment
#
curl -X 'PATCH' \
  "http://93.28.23.252:8080/api/v2/shop/orders/$cmdToken/payments/$payId" \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/merge-patch+json' \
  -d '{
  "paymentMethod": "ofty_strip"
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
'
