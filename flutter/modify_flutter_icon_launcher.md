# Modification de l'icône de démarrage de Flutter


## Création de l'icône d'image

1. Tout d'abord, ajoutez l'image qui sera utilisée comme icône du projet dans le répertoire des ressources (assets). Dans notre exemple, elle sera sauvegardée dans le répertoire suivant :

    ```shell
    assets/images/icon.png
    ```

## Installation du package flutter_launcher_icons

2. Ensuite, vous devrez installer le package flutter_launcher_icons. Il s'agit d'un outil en ligne de commande qui simplifie la tâche de mise à jour de l'icône de démarrage de votre application Flutter. Entièrement flexible, il vous permet de choisir la plateforme pour laquelle vous souhaitez mettre à jour l'icône de démarrage et, si vous le souhaitez, l'option de conserver votre ancienne icône de démarrage au cas où vous voudriez revenir en arrière ultérieurement.

    ```shell
    flutter pub add flutter_launcher_icons
    ```

## Configuration du fichier de configuration

3. Ajoutez votre configuration Flutter Launcher Icons à votre fichier pubspec.yaml ou créez un nouveau fichier de configuration appelé flutter_launcher_icons.yaml. Un exemple est présenté ci-dessous.

    ```yaml
    dev_dependencies:
      flutter_launcher_icons: "^0.13.1"

    flutter_launcher_icons:
      android: "launcher_icon"
      ios: true
      image_path: "assets/icon/icon.png"
      min_sdk_android: 21 # android min sdk min:16, default 21
      web:
        generate: true
        image_path: "path/to/image.png"
        background_color: "#hexcode"
        theme_color: "#hexcode"
      windows:
        generate: true
        image_path: "path/to/image.png"
        icon_size: 48 # min:48, max:256, default: 48
      macos:
        generate: true
        image_path: "path/to/image.png"
    ```

    Si vous donnez à votre fichier de configuration un nom différent de flutter_launcher_icons.yaml ou pubspec.yaml, vous devrez spécifier le nom du fichier lors de l'exécution du package.

    ```shell
    flutter pub get
    flutter pub run flutter_launcher_icons -f <votre nom de fichier de configuration ici>
    ```

    Note : Si vous n'utilisez pas le pubspec.yaml existant, assurez-vous que votre fichier de configuration est situé dans le même répertoire que celui-ci.

## Exécution du package

4. Après avoir configuré le fichier de configuration, il ne vous reste plus qu'à exécuter le package.

    ```shell
    flutter pub get
    flutter pub run flutter_launcher_icons
    ```