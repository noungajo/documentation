# Libellé de contenu

Il s'agit ici de produire une application qui est utilisable par tout le monde (également pour les mal voyants). Il faudra donc ajouter du texte (libellé) sur chaque item de votre application qui sera lu par une application du genre talback.
Exemple : si un malvoyant est sur un bouton qui permet d'incrémenter, il faudra que le libellé incrémenté soit audible afin qu'il sache ce qu'il faut faire pendant qu'il utilise l'application.

# Ajout de libellé de contenu

**Bouton** : une propriété que nous pouvons utiliser pour rendre un bouton lisible est **"tooltip":**
```dart
floatingActionButton: FloatingActionButton(
 onPressed: _incrementCounter,
 tooltip:"Increment",
 child:Icon(Icons.add),
```

De cette façon lorsque le lecteur d'accessibilité trouvera cet élément, il lira le texte qui a été attribué à cette propriété.

**Iage, Icon ...:** Pour la pluspart des widgets nous avons pas la propriété "tooltip", mais nous avons **"semanticLabel"** qui a le même objectif:

```dart
Image.asset(
 'assets/dog.png',
 semanticLabel:"This image reprents a dog"
),
```

**Autres widgets** : certains widgets n'ont pas la propriété "semanticLabel". Pour cela il faut envelopper le widget avec un widget spécial appelé **"Semantics"**. Ce widget contient une propriété "label" où nous devons spécifier le texte à lire:

```dart
Semantics(
 label:"This is a custom widget",
child : MyCustomWidget(),
),
```

**Lire du texte** : Si l'application lit un texte, elle lira par défaut la chaîne exacte de ce texte, mais que faire si vous avez, par exemple, un texte contenant "35 km/h" ? Cela sera lu comme "trente-cinq km slash h". La lecture correcte devrait être "trente-cinq kilomètres par heure".
Dans le widget Texte, nous n'avons pas de propriété "tooltip" ou "semanticLabel", mais plutôt "semanticsLabel" (remarquez le S) :

```dart
Text(
 "$speed" + " km/h",
 semanticsLabel: "$speed" + " kilometers per hour",
),
```
