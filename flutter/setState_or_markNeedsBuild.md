# [Solved] setState() or markNeedsBuild() called during build Error

Dans cette documentation nous allons montrer comment résoudre l'erreur "setState() or markNeedsBuild() called during build" dans une application flutter. Cette erreur se produit lorsque vous appelez setState dans la méthode de construction du widget.
## Cause de l'erreur
Cette erreur se produit lorsque vous essayez d'afficher une boîte de dialogue d'alerte (ou tout autre) avant la fin de la construction du widget.
Par exemple:

```dart
Widget build(BuildContext context) {

  showDialog(
    context: context,
    builder: (BuildContext context) {
        return AlertDialog(
          title: Text("How are you?"),
        );
  }); //Error: setState() or markNeedsBuild() called during build.

  return Scaffold(
        body: Center(
          child: Text("Hello World")      
        )
  );
} 
```

Ici, la méthode showDialog() est appelée à l'intérieur de la méthode de construction du widget, ce qui provoque l'erreur d'exécution. Dans votre cas, il doit y avoir un autre scénario de code à l'intérieur du widget build qui utilise setState.

## Solution de l'erreur

Pour resoudre cette erreur, vous devez envelopper votre code actuel avec :

```dart
Widget build(BuildContext context) {

  Future.delayed(Duration.zero,(){
       //your code goes here
  });

  return Scaffold(
        //widget tree
  );
} 
```
Si vous voulez appeler *showDialog()* ou on veut exécuter n'importe quel autre code qui appelle *setState()*,  alors utiliser la méthode *Future.delayed()* comme suivant : 

```dart
Widget build(BuildContext context) {

  Future.delayed(Duration.zero,(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
          return AlertDialog(
            title: Text("How are you?"),
          );
    });
  });

  return Scaffold(
        body: Center(
          child: Text("Hello World")      
        )
  );
}
```

De cette façon, vous pouvez résoudre l'erreur "setState() ou markNeedsBuild() appelée pendant la construction" dans l'application Flutter.

[Lien pour plus de détails](https://www.fluttercampus.com/guide/230/setstate-or-markneedsbuild-called-during-build/)

> Noutcha Ngapi Jonathan, OFTY Cameroun.