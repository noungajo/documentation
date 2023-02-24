# Flutter Insecure http is not allowed by platform
 ## Android
Open the **AndroidManifest.xml** file in the **android/app/src/main** folder. Then set *usesCleartextTraffic* to *true*.

```xml
<application
    ...
    android:usesCleartextTraffic="true"
    ...
>
```

## IOS
Open the Info.plist file in the **ios/Runner** folder. Then add the following key.
```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
      <true/>
</dict>
```
# Flutter Firestore causing D8: Cannot fit requested classes in a single dex file (# methods: 71610 > 65536) in Android Studio
## Enable multidex.

Open `project/app/build.gradle` and add the following lines.

```dart
defaultConfig {
    ...

    multiDexEnabled true
}
```
and
```dart
dependencies {
    ...

    implementation 'com.android.support:multidex:1.0.3'
}
```

If you have migrated to AndroidX, you'll want this instead 

```dart
dependencies {
    ...

    implementation 'androidx.multidex:multidex:2.0.1'
}
```

# Bugg observé lorsque introduction de GetxController

> [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: Binding has not yet been initialized.

La raison en est que vous attendez des données ou exécutez une fonction asynchrone dans main().
Il existe une toute petite solution. Exécutez simplement WidgetsFlutterBinding.ensureInitialized() dans void main(), avant de lancer runApp(). Cela fonctionne comme un charme !
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // your code
}
```

