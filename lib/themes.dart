import 'package:flutter/material.dart';

class MydoThemes {
  static final lightTheme = ThemeData(
    primaryColor: Colors.indigo,
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFF233882),
    brightness: Brightness.dark,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.black54,
      selectionHandleColor: Colors.white,
    ),
  );
}

class MydoColors {
  //static final todaySection = const Color(0xFF410069);
  //static final soonSection = Colors.lime;
  //static final eventuallySection = Colors.lightGreen;

  static final incompleteCard = const Color(0xFFFF8F8F);
  static final timedTodayCard = const Color(0xFFFFC155);
  static final untimedTodayCard = const Color(0xFFFFC155);
  //static final soonCard = const Color(0xFFE8A6FF);
  //static final eventuallyCard = const Color(0xFFFF9DBA);
  static final soonCard = const Color(0xFFFFF295);
  static final eventuallyCard = const Color(0xFFDDFF95);
  static final pastCard = const Color(0xFFDDE7FF);

  static final dialogBG = const Color(0xFF232323);
  static final dialogOutlineFocused = const Color(0xFFD2D2E2);
  static final dialogOutlineUnfocused = const Color(0xFF66666D);

  static final navbar = const Color(0xFF242424);
  static final systemNavbar = const Color(0xFF131313);

  static final segmentedButtonPlanned = const Color(0xFFF3A621);
  static final segmentedButtonSoon = const Color(0xFFF9E457);
  static final segmentedButtonEventually = const Color(0xFF9CD640);
  static final segmentedButtonBG = const Color(0xFF242424);
  static final segmentedButtonBorder = Colors.transparent;
}

class MydoGradients {
  static const incompleteSection = LinearGradient(
      colors: <Color> [
        Color(0xFFF16262),
        Color(0xFFE64747),
      ]
  );
  static const todaySection = LinearGradient(
      colors: <Color>[
        Color(0xFFF3A621),
        Color(0xFFF38021),
      ]
  );
  static const soonSection = LinearGradient(
    colors: <Color> [
      Color(0xFFF9E457),
      Color(0xFFF5D91A),
    ]
  );
  static const eventuallySection = LinearGradient(
    colors: <Color> [
      Color(0xFF9CD640),
      Color(0xFF6CCB18),
    ]
  );
  static const dateSection = LinearGradient(
    colors: <Color> [
      Color(0xFFB2BEDC),
      Color(0xFF889CCC),
    ]
  );
  //static const futureSection = LinearGradient(
  //    colors: <Color> [
  //      Color(),
  //      Color(),
  //    ]
  //);
}

class MydoText {
  static TextStyle cardEditText = TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static TextStyle categoryHeaders = TextStyle(
    fontSize: 16,
    color: Colors.black
  );

  static TextStyle dialogEditor = TextStyle(
    fontSize: 20,
    color: Color(0xFFD2D2E2)
  );

  static TextStyle resetButton = TextStyle(
    color: Color(0xFFFF6464)
  );
}
