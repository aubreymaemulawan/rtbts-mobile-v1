
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/unused/profile_page.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Services/globals.dart';
import 'pages/splash_screen.dart';

import 'package:flutter_login_ui/pages/login_page.dart';
void main() {
  runApp(LoginUiApp());
}
//
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   var email = preferences.getString('email');
//   runApp(MaterialApp(home: email == null ? LoginPage() : ProfilePage(),));
// }

class LoginUiApp extends StatelessWidget {

  // Color _primaryColor = HexColor('#DC54FE');
  // Color _accentColor = HexColor('#8A02AE');

  // Design color
  // Color _primaryColor= HexColor('#FFC867');
  // Color _accentColor= HexColor('#FF3CBD');

  // Our Logo Color
  // Color _primaryColor= HexColor('#D44CF6');
  // Color _accentColor= HexColor('#5E18C8');

  // Our Logo Blue Color
  Color _primaryColor= HexColor('#5885AF');
  Color _accentColor= HexColor('#274472');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RTBTS',
      theme: ThemeData(
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(title: 'RTBTS'),
    );
  }
}


