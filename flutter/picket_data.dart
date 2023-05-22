 String _selectedDate =
      DateTime.now().toString().substring(0, 10); //la date choisit

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
        locale: const Locale("fr", "FR"),
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2024),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xffC41028), // <-- SEE HERE
                onPrimary: Colors.white, // <-- SEE HERE
                onSurface: Colors.black, // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor:
                      const Color(0xffC41028), // couleur bouton en dessous
                ),
              ),
            ),
            child: child!,
          );
        });
    if (d != null) {
      setState(() {
        _selectedDate = DateFormat("yyyy-MM-dd").format(d);
      });
    }
  }
