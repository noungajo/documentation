# Exécution d'une API en utilisant l'émulateur android

<div style="text-align: justify"> Lors du développement d'une application mobile qui fonctionne avec une API l'exécutiion ne fonctionne pas sans une configuration au préalable. </div>


## Configutation côté mobile

une fois votre émulateur mobile installé, suivez ces étapes:

> vérifier que le wifi est activé
> vérifier que l'émulateur a accès à internet lorsque l'ordinateur est connecté
> allez dans le fichier 
 
```bash 
android\app\src\main\AndroidManifest.xml
```

Ajouter les lignes suivantes entre la balise \<manifest> et la balise \<application>

```xml
   
   <manifest>

    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE"/>
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-feature android:name="android.hardware.wifi" />

    <application>
```
> <div style="text-align: justify">Comme la partie mobile gère la conncection à l'API alors dans le module qui gère la connexion, le module client, modifier l'url de base par l'adresse IP de la machine hôte. </div>

```dart
Client(){
     var options = BaseOptions(
        baseUrl: 'http://192.168.100.19:8080',
       ...
      );
   ...
  }
```

> Pour avoir son adresse IP, ouvrez l'invite de commande et taper:

```bash
# sur windows
ipconfig

#sur Linux
ifconfig
```

## Du côté de l'API

<div style="text-align: justify">pour cette documentation nous allons juste présenter l'API Django. Le serveur Django devra être lancé sur l'adresse IP de la machine hôte. Car du côté mobile c'est l'url de base, cela est fait pour permettre à l'émulateur de pouvoir communiquer avec la machine hôte, et vu qu'elle héberge un serveur de communiquer avec lui via le port saisie. Pour cela on lance le serveur Django ainsi:</div>

```shell
python manage.py runserver 192.168.100.19:8080

```
