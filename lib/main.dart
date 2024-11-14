import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Local
import 'package:mydo/themes.dart';
import 'home.dart';

void main() {
  var style = SystemUiOverlayStyle(
    systemNavigationBarColor: MydoColors.systemNavbar
  );
  SystemChrome.setSystemUIOverlayStyle(style);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Mydo());
}

class Mydo extends StatelessWidget {
  const Mydo({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mydo',
      theme: MydoThemes.darkTheme,
      home: const HomePage(title: 'Mydo'),
    );
  }
}


