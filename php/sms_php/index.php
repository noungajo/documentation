<html>
<body>
  <h1> SMS Query</h1>

<?php
require_once 'vendor/autoload.php'; // Inclure le fichier autoload.php

function sendsms($message, $receiver_phone) {
  

  // client instanciation
    $AUTH_TOKEN = "Basic cWVqSW1BRDRndTFlbzh1anBFZ3RnQ2FpMVpkV0VReWo6YVZjU3ZwRWxlSHpmdEFhSw==";
// demande du token d'access
    $url = "https://api.orange.com/oauth/v3/token";
    $headers = array(
      "Authorization: ".  $AUTH_TOKEN,
    "Content-Type: application/x-www-form-urlencoded",
    "Accept: application/json");
    $data = [
      "grant_type" => "client_credentials"
    ];
    $ch = curl_init();
    curl_setopt($ch,CURLOPT_URL,$url);
    curl_setopt($ch,CURLOPT_POST,1);
    curl_setopt($ch,CURLOPT_POSTFIELDS,http_build_query($data));
    curl_setopt($ch,CURLOPT_HTTPHEADER,$headers);
    curl_setopt($ch,CURLOPT_RETURNTRANSFER,1);

    $resp = curl_exec($ch);
    $tokenType = "";
    $token = "";
    if($resp==curl_error($ch)){
      echo "Fail: avec quelques ratés".`<br>`;
      echo $resp;
    }else{
      $decoded = json_decode($resp);
      foreach($decoded as $key => $val){
        if($key == "token_type"){
          $tokenType = $val;
        }
        if($key == "access_token"){
          $token = $val;
        }
      }
    }
    
    curl_close($ch);
    print "---------------------------fin----------------------------------".`<br>` ;

    print"---------------------------------- envoie des sms ---------------------".`<br>`;
   $auth = $tokenType." ".$token;
    $sender_phone = "2370000";
    $newurl = 'https://api.orange.com/smsmessaging/v1/outbound/tel%3A%2B' . $sender_phone . '/requests';
   
    $newHeaders = array(
      "Authorization:".  $auth,
    "Content-Type: application/json",
    "Accept: application/json");
    $data2 = array(
         "outboundSMSMessageRequest" => array(
                  "address" => "tel:+" . $receiver_phone,
                  "senderAddress" => "tel:+" . $sender_phone,
                  "outboundSMSTextMessage" => array(
                    "message" => $message
                  )
                )
              );
      $data2 = json_encode($data2);
  $ch2 = curl_init();
  curl_setopt($ch2,CURLOPT_URL,$newurl);
  curl_setopt($ch2,CURLOPT_POST,1);
  curl_setopt($ch2,CURLOPT_POSTFIELDS,$data2);
  curl_setopt($ch2,CURLOPT_HTTPHEADER,$newHeaders);
  curl_setopt($ch2,CURLOPT_RETURNTRANSFER,1);


  $resp2 = curl_exec($ch2);
print"-------------------------- fin ---------------------------------";
   if($resp2==curl_error($ch2)){
      echo "Fail: avec quelques ratés".`<br>`;
      echo $resp2;
    }else{
      var_dump($resp2);
      $decoded2 = json_decode($resp2);
      echo "Je suis le meilleur: et ça marche".`<br>`;
      foreach($decoded2 as $key => $val){
        echo $key .': '.$val. `<br>`;
      }
    }
    curl_close($ch2);
    
}
sendsms("Hello Durango confirme par whatsapp si tu as le sms. c'est Brice je tes l'api orange",'690291718');
?>
</body>
</html>
