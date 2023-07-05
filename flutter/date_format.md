# Ici nous allons parler du formatage de la date

# Package
```dart
import 'package:intl/intl.dart';
```
# code
```dart
initializeDateFormatting(language);
DateFormat formater = DateFormat.yMMMMd(language)
String date = formatter.format(DateTime a formater)

```

format obtenu : 5 Juillet 2023

```dart
initializeDateFormatting(language);
DateFormat formater = DateFormat.yMMMMEEEEd(language)
String date = formatter.format(DateTime a formater)

```

format obtenu : Mercredi 5 Juillet 2023

```dart
DateFormat formater = DateFormat('yyyyMMdd')
String date = formatter.format(DateTime a formater)

```

format obtenu : 20230705
