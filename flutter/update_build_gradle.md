# Error : Mapping new ns to old ns
message en console

```shell
Launching lib\main.dart on ONEPLUS A6010 in debug mode...
Running Gradle task 'assembleDebug'...
Warning: Mapping new ns http://schemas.android.com/repository/android/common/02 to old ns http://schemas.android.com/repository/android/common/01
Warning: Mapping new ns http://schemas.android.com/repository/android/generic/02 to old ns http://schemas.android.com/repository/android/generic/01
Warning: Mapping new ns http://schemas.android.com/sdk/android/repo/addon2/02 to old ns http://schemas.android.com/sdk/android/repo/addon2/01
Warning: Mapping new ns http://schemas.android.com/sdk/android/repo/addon2/03 to old ns http://schemas.android.com/sdk/android/repo/addon2/01
Warning: Mapping new ns http://schemas.android.com/sdk/android/repo/repository2/02 to old ns http://schemas.android.com/sdk/android/repo/repository2/01
Warning: Mapping new ns http://schemas.android.com/sdk/android/repo/repository2/03 to old ns http://schemas.android.com/sdk/android/repo/repository2/01
Warning: Mapping new ns http://schemas.android.com/sdk/android/repo/sys-img2/03 to old ns http://schemas.android.com/sdk/android/repo/sys-img2/01
Warning: Mapping new ns http://schemas.android.com/sdk/android/repo/sys-img2/02 to old ns http://schemas.android.com/sdk/android/repo/sys-img2/01
Warning: unexpected element (uri:"", local:"base-extension"). Expected elements are <{}codename>,<{}layoutlib>,<{}api-level>
```
# Solution

## 1. Nettoyer le projet
Taper la commande

```shell
flutter clean
```
se rassurer que les repertoires <projet>/build et <projet>/android/build ont été effacé

## 2. Mettre à jour gradle.properties

Aller dans le fichier gradle-wrapper.properties qui est dans le répertoire <projet>/android/gradle et mettre la valeur de distributionUrl à la version la plus récente de gradle, Aujourd'hui voici ce que j'ai *https\://services.gradle.org/distributions/gradle-7.4-bin.zip* 

contenu du fichier <projet>/android/gradle/gradle-wrapper.properties
```shell
distributionBase=GRADLE_USER_HOME
distributionUrl=https\://services.gradle.org/distributions/gradle-7.4-bin.zip
distributionPath=wrapper/dists
zipStorePath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
```
## 3. Mettre à jour le projet build.gradle

Mettre à jour le build.gradle d'Android localisé à <projet>/android/build.gradle avec la nouvelle version de gradle et kotlin disponible. Chez moi j'ai
ext.kotlin_version = '1.6.10' et classpath 'com.android.tools.build:gradle:7.1.1'

le fichier <projet>/android/build.gradle devient donc

```shell
buildscript {
    ext.kotlin_version = '1.6.10'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.1.1'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.3.10'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
    project.evaluationDependsOn(':app')
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
```

## 4. Étape finale

exécuter la commande
```shell
flutter packages get
```

