# Singer une application

Pour publier une application sur playstore, il faut donner à l'application une signature digitale.

> Sur Android, il existe deux clés de signature : déploiement et téléchargement. Les utilisateurs finaux téléchargent le .apk signé avec la "clé de déploiement". Une "clé de téléchargement" est utilisée pour authentifier les .aab / .apk téléchargés par les développeurs sur le Play Store et est re-signée avec la clé de déploiement une fois dans le Play Store.
>Il est fortement recommandé d'utiliser la signature automatique gérée par le cloud pour la clé de déploiement.

## Create an upload keystore

Si vous avez un keystore existant, passez à l'étape suivante. Sinon, créez-en un :

sur linux ou sur mac utiliser les commandes suivantes:
Copier le chemin de votre projet au repertoire ~nom_projet/android/app/ et coller ce chemin suivant la seconde commande de chaque version du système d'exploitation

- Linux/mac
```shell
  keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  keytool -genkey -v -keystore /home/user_name/Documents/projects/nom_projet/android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

- Windows
```shell
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
  keytool -genkey -v -keystore /C/user_name/Documents/projects/nom_projet/android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

```
- Entrer un mot de passe : mon_mot_de_passe
- noms et prenom : andaal store
- nom de l'unité organisationnelle : 
- nom de l'entreprise : OFTY
- ville : Yaoundé
- Province : Centre
- PAys : Cameroun
- puis valider oui

Le message ci-dessous s'affiche

```shell

Génération d'une paire de clés RSA de 2 048 bits et d'un certificat auto-signé (SHA256withRSA) d'une validité de 10 000 jours
	pour : CN=andaal store, OU=OFTY, O=OFTY, L=Yaoundé, ST=Centre, C=Cameroun
[Stockage de /home/stage/Documents/projets/andaal/frontend/andal/android/app/upload-keystore.jks]

```
à ce stade le keystore est déjà télchargé dans notre projet. Maintenant il va falloir l'intégrer

## Reference the keystore from the app

Créer un nouveau fichier nommé [nom_projet]/android/key.properties. Puis copier et coller ce code

```shell
storePassword=<le mot de passe saisi lors de la génération du keystore>
keyPassword=<retaper le même mot de passe>
keyAlias=upload
storeFile=<chemin du fichier keystore, du style /Users/<user name>/upload-keystore.jks>

```

## Configure signing in gradle
Configurez le gradle pour qu'il utilise la clé de téléchargement lors de la construction de l'application en mode release en modifiant le fichier [nom_projet]/android/app/build.gradle

1. copier ce code avant la propriété android

```shell
   def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }
   android{
    ...
   }
```
Charge le fichier key.properties dans l'objet keystoreProperties.
bien respecter l'indentation

2. trouver le bloc buildTypes du même fichier

remplacer le code ci-dessous
```shell
   buildTypes {
       release {
           // TODO: Add your own signing config for the release build.
           // Signing with the debug keys for now,
           // so `flutter run --release` works.
           signingConfig signingConfigs.debug
       }
   }

```
par celui-ci

```shell
   signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   buildTypes {
       release {
           signingConfig signingConfigs.release
       }
   }

```

Les versions de votre application seront désormais signées automatiquement.

> Remarque : Vous devrez peut-être exécuter flutter clean après avoir modifié le fichier gradle. Cela empêche les builds en cache d'affecter le processus de signature.

## Shrinking your code with R8

sauvegarder tout et saisir la commande
```shell
flutter build appbundle
```
R8 est le nouveau réducteur de code de Google, et il est activé par défaut lorsque vous construisez une version APK ou AAB. Pour désactiver R8, passez le drapeau --no-shrink à flutter build apk ou flutter build appbundle.

## Imprévu
Il peut y arriver qu'une erreur se présente. Celle que j'ai rencontrée et résolue est :

> Error building AAB - Flutter (Android) - Integrity check failed: java.security.NoSuchAlgorithmException: Algorithm HmacPBESHA256 not available
> solution : ajouter l'attribut en plus ci-dessous
```shell
-storetype JKS
```
La balise -storetype JKS n'est requise que pour Java 9 ou une version plus récente. À partir de la version Java 9, le type de keystore est par défaut PKS12.