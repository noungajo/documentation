# Réalisation d'un timer Flutter
voici un example de timer utilisant Timer.periodic

## importation
```dart
import 'dart:async';
```

## Variable à utiser
initialisation de la durée à 70 secondes.

```dart
Timer _timer;
int _start = 70;

``` 

## Function de décrémentation du temps

```dart
void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    },
  );
}

@override
void dispose() {
  _timer.cancel();
  super.dispose();
}
```

## Formatage de l'affichage du timer
il faut utiliser la division entière *(~/)* pour obtenir le nombre de minutes et le reste de la division *(%)* pour obtenir les secondes.
fonction pour convertir une durée en seconde en format "minutes:secondes"
```dart
String formatDuration(int durationInSeconds) {
  int minutes = durationInSeconds ~/ 60;
  int seconds = durationInSeconds % 60;

  String minutesString = minutes.toString().padLeft(2, '0');
  String secondsString = seconds.toString().padLeft(2, '0');

  return '$minutesString:$secondsString';
}
```
test de la fonction
```dart
void main() {
  int durationInSeconds = 70;
  String formattedDuration = formatDuration(durationInSeconds);
  print(formattedDuration);  // Affiche : 01:10
}
```
## Interface
bouton qui affiche l'état du compteur
```dart
Widget build(BuildContext context) {
  return new Scaffold(
    appBar: AppBar(title: Text("Timer test")),
    body: Column(
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            startTimer();
          },
          child: Text("start"),
        ),
        Text("$_start")
      ],
    ),
  );
}
```
