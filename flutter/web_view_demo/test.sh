$token = "jcxEW3eaKr"
###
curl -X 'GET' -L  \
  "http://93.28.23.252:8080/fr/order/$token/pay" \
  -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE2ODQ3NTQyNTMsImV4cCI6MTY4NDc1Nzg1Mywicm9sZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJuYW1lIjoicHJvZG9mZmFub2liZS0yNDg2QHlvcG1haWwuY29tIn0.Um8BUSy53OQwZlR6-wsqKQkCGz5nXEUeQyw02qMmIFRjg4uPia-65R5osiB-crUtHzb4mnUK8TblQK4sNwnOomVxELry4xPa8R87TN-BYESwJ0Iss8dsDAglftiO2i_NXli3FviaSU86OxQ01XxqszeK2IZj9zv1HCLSQejF-9l3KgO3gq8hf0LAnL7Z0EitxYjdmRoTrempXFXy2Yo4FAsJYKZigbTAOSrNpH4nKHmXRq6TPNb4Y2RLTnXRGvcMYavtOnlGATxWnIchJVVTs-ZhLmVfXxPvY70vbNTCdPFQVHxB-IUNdoRGohtBC1JpCq8RZTTCdSj-OsY06DXLyQ"

webview_flutter: ^4.2.0
  webview_flutter_android: ^3.7.0
  webview_flutter_wkwebview: ^3.4.3
  flutter_webview_plugin: ^0.4.0