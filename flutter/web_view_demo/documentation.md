# WebView

## Installation and configuration
```dart
flutter pub add webview_flutter
```

import
```dart
import 'package:webview_flutter/webview_flutter.dart';
```

modify your *android/app/build.gradle* file as follows

```dart
  minSdkVersion 20
  targetSdkVersion 30
```

## Configuration
Pour permettre à un endpoint http de requêter un lien https

- Ouvrir le fichier *android/app/src/AndroidManifest.xml* et ajouter le code suivant dans la balise application :

```xml
   <application
        ...
        android:networkSecurityConfig="@xml/network_security_config"
        >
```

- Créer un repertoire xml et un fichier dans le repertoire *android/app/src/main/res/xml/network_security_config.xml* . Et ajouter le code ci-dessous :
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true">
        <trust-anchors>
            <certificates src="system" />
            <certificates src="user" />
        </trust-anchors>
    </base-config>
</network-security-config>
```

> Configuration à supprimer au moment d'aller en mode production.
