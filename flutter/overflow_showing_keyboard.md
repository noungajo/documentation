# Bottom overflowed by x pixels when showing keyboard

## Solution 1

In your Scaffold, set "resizeToAvoidBottomInset" property to false.

```dart
 return Scaffold(
      resizeToAvoidBottomInset : false,
      body: YourWidgets(),
    );
```
> this solution is the most simple and the most use

## Solution 2
Force your column to be the same height as the screen, then place it in a SingleChildScrollView so that Flutter automatically scrolls the screen up just enough when the keyboard is used.

```dart
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // CONTENT HERE
            ],
          ),
        ),
      ),
    ),
  );
}
```
