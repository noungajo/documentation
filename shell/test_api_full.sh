
#!/bin/bash

shipId=0
payId=0

user=${1:-defualt_user}
passwd=${2:-default_pass}
elementIdx=${3:-0}

if [ $# -lt 3 ]
then
  echo please enter user_email passwd and product varian idx
  echo "Ex: .$0 toto@gmail.com titi1234 12 "

fi


cmdToken=""
token=""
variant=""


#====== SETUP TEST DIRECTORY
ID=`uuidgen`
mkdir -p test_andaal/$ID
pushd  test_andaal/$ID

echo  rungin test in test_andaal/$ID , this will be erase at the end of test


# Begin test functions

#Send reset password
function reset_password() {
curl -X 'POST' \
  'http://93.28.23.252:8080/api/v2/shop/reset-password-requests' \
  -H 'accept: */*' \
  -H 'Content-Type: application/ld+json' \
  -d "{
  \"email\": \"$user\",
  \"locale\": \"fr\"
}"
}

#Login user

function login()
{
echo 1. LOGIN_USER
token=$(curl -s -X 'POST' \
  'http://93.28.23.252:8080/api/v2/shop/authentication-token' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "{
  \"email\": \"$user\",
  \"password\": \"$passwd\"
}" | jq ".token" | sed 's/"//g' )
}
#echo $token

function listAddressOfUser(){
echo LIST USER ADDRESSES

curl -s -X 'GET' \
  'http://93.28.23.252:8080/api/v2/shop/addresses?page=1&itemsPerPage=30' \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" | jq .

}

function update_address()
{
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

# Choose article
# How to call :  variant=`choose_product_variant`

function choose_product_variant() {
 p1="jq '.[\"hydra:member\"]"
 p2="[$elementIdx]|.product'"

variant=$(curl -s -X 'GET' \
  'http://93.28.23.252:8080/api/v2/shop/product-variants?page=1&itemsPerPage=30' \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" | eval "${p1}${p2}" | sed -e 's/"//g')
  echo "$variant"
}

#Pick cart
function pick_cart(){
echo PICKUP CART

cmdToken=$(curl -s -X 'POST' \
  'http://93.28.23.252:8080/api/v2/shop/orders' \
  -H 'accept: application/ld+json' \
  -H "Authorization: Bearer $token" \
  -H 'Content-Type: application/ld+json' \
  -d '{}' | jq ".tokenValue" | sed 's/"//g')

echo $cmdToken
}

# Add item to cart
#
function add_item(){
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
}
function available_shippemet(){
  echo AVAILABLE SHIPPEMENT
  jq '.shipments[].method' order.json
}

function available_payment(){
echo AVAILABLE PAYMENT
jq '.payments[].method' order.json
}

function list_countries(){
echo ALL COUNTRIES

curl -s -X 'GET' \
  'http://93.28.23.252:8080/api/v2/shop/countries?page=1&itemsPerPage=30' \
  -H 'accept: application/ld+json' |  jq '.["hydra:member"][0] | "Country: "+ .name + ", Code: " + .code '
}

#Address order
function address_cmd(){
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
    "provinceCode": "CM-LT",
    "provinceName": "Littoral",
    "street": "Bonapriso",
    "city": "Douala",
    "postcode": "123"
  }
}' | jq '.'   > ./order.json
}
echo AVAILABLE SHIPPEMENTS METHODS


# How to call :       method=`get_ship_method_from_order`
#
function get_ship_method_from_order(){
  method=$(jq '.shipments[].method' order.json |  sed -e 's/"//g' | cut -d '/' -f 6)
  echo $method
}

# How to call :       method=`get_paym_method_from_order`
#
function get_pay_method_from_order(){
paymethod=$(jq '.payments[].method' order.json |  sed -e 's/"//g' | cut -d '/' -f 6)
echo $paymethod
}

function get_pay_and_metho_id(){
  shipId=$(jq ".shipments[].id" order.json)
  payId=$(jq ".payments[].id" order.json)
}


function apply_pay_and_ship_to_order() {
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
  -d "{
  \"paymentMethod\": \"$paymethod\"
}
" | jq . >/dev/null
}


#
function place_order_and_pay()
{
    if [ $paymethod == "ofty_strip" ]
    then

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
    else

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

    fi
}

## Make you scenario here ...








# TEST END
popd
rm -rf test_andaal/$ID

