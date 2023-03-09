
# Andaal

## Description
"Andaal" est une application qui vise à faciliter l'accès au savoir culturel africain en général, et au livre scolaire en particulier.

## Status du projet
Le projet est dans sa phase test. Une première release a été publiée sur PlayStore. Elle sert version béta pour avoir les sensations des utilisateurs au contact de l'application.

## Démarrer avec le projet

    ### Dépendance

        #### requirement

            - environment:
            sdk: ">=2.12.0 <3.0.0"
            - logger: ^1.1.0
            - dio: ^4.0.4
            - get: ^4.6.1
            - searchfield: ^0.5.6
            - responsive_grid: ^2.0.0
            - flutter_svg: ^1.0.3
            - google_fonts: 2.2.0
            - badges: ^2.0.2
            - flutter_launcher_icons: ^0.9.2
            - jmespath: ^2.0.1
            - pdf: ^3.8.2
            - printing: ^5.9.2
            - intl: ^0.17.0
            - dropdown_button2: ^1.4.0
            - intl_phone_number_input: ^0.7.0+2
            - sn_progress_dialog: ^1.1.3
            - pretty_dio_logger: ^1.2.0-beta-1
            - country_picker: ^2.0.19
            - url_launcher: ^6.1.8
            - new_version: ^0.3.1
            - uuid: ^3.0.7

        #### Outils utilisés
            - Ubuntu 20.04.5 LTS
            - VS Code 1.76.0
            - Flutterwave_standard
            - openjdk version "11.0.18" 2023-01-17
            OpenJDK Runtime Environment OpenLogic-OpenJDK (build 11.0.18+10-adhoc.root.jdk11u)
            OpenJDK 64-Bit Server VM OpenLogic-OpenJDK (build 11.0.18+10-adhoc.root.jdk11u, mixed mode)
            - Flutter 3.7.5 • channel stable • https://github.com/flutter/flutter.git
            Framework • revision c07f788888 (il y a 2 semaines) • 2023-02-22 17:52:33 -0600
            Engine • revision 0f359063c4
            Tools • Dart 2.19.2 • DevTools 2.20.1
            - Android Studio Bumblebee 2021.1.1 Patch 3 AI-211.7628.21.2111.8309675 March 16, 2022

    ### Installation de l'environnement de développement
        Ouvrir un terminal et suivre les étapes ci-dessous 

        - Installation flutter via la commande
        ```shell
            sudo snap install flutter --classic
        ```
        
        - Installation de Java Jdk via la commande
        ```shell
            sudo apt install openjdk-11-jdk
        ```
        - Installation de Android Studio via la commande
        ```shell
            sudo snap install android-studio --classic
        ```
        - Flutterwave_standard : 
            * cloner le repository : [depôt officiel Flutterwave_standard](https://github.com/Flutterwave/Flutter.git)
            * ajouter le chemin au repository dans le fichier pubspec.yaml. il ressemblera à ceci :
                ```Dart
                    flutterwave_standard:
                        path: "[chemin absolue du depôt cloné]/Flutter"
                ```
        - Installation des requirements : dans le porjet taper la commande ci dessous : 
            ```shell
                    flutter pub get
                ```

    ### Démarrage
        Dans le projet taper la commande : 
        ```shell
            flutter run
        ```
        Puis choisir l'émulateur sur lequel le porjet va être exécuté.

## Contributeur
`@OFTY`
## Historique des versions
    - 1.0.1
        * Release initiale
        * Déploiement sur PlayStore (version cible incompatible)
        * mise à jour de la version cible (mise à jour de l'API de paiement flutterwave et de l'environnement de développement)
    - 1.0.2
        * Test interne google
        * Stabilité 0
        * problèmes d'accessibilité 3
        * problèmes de performance 1
        * problèmes de sécurité et fiabilité 1
    - 1.0.3
        * Test interne google
        * Stabilité 0
        * problèmes d'accessibilité 3
        * problèmes de performance 2
        * problèmes de sécurité et fiabilité 1
    - 1.0.4
        * Test interne google
        * Stabilité 0
        * problèmes d'accessibilité 3
        * problèmes de performance 2
        * problèmes de sécurité et fiabilité 1
    - 1.0.5
        * correction des bloblèmes
        * Déploiement(lien de la clause de confidentialité non valide)
    - 1.0.6
        * correction des bloblèmes
        * Déploiement(lien de la clause de confidentialité non valide)
    - 1.0.7
        * Test interne google
        * Stabilité 0
        * problèmes d'accessibilité 3
        * problèmes de performance 2
        * problèmes de sécurité et fiabilité 0
    - 1.0.8
        * Test interne google
        * Stabilité 0
        * problèmes d'accessibilité 4
        * problèmes de performance 1
        * problèmes de sécurité et fiabilité 0
    - 1.0.9
        * Test interne google
        * Stabilité 0
        * problèmes d'accessibilité 3
        * problèmes de performance 2
        * problèmes de sécurité et fiabilité 0
    - 1.0.10
        * Test interne google
        * Stabilité 0
        * problèmes d'accessibilité 4
        * problèmes de performance 2
        * problèmes de sécurité et fiabilité 0
    - 1.0.10
        * Déploiement (complet)




## Licence
    copyrigth 