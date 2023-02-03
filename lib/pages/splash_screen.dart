import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/unused/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';
import 'login_page.dart';
import 'dashboard.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  _SplashScreenState(){

    // new Timer(const Duration(milliseconds: 2000), (){
    //   setState(() {
    //     Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
    //   });
    // });
    //
    // new Timer(
    //   Duration(milliseconds: 10),(){
    //     setState(() {
    //       _isVisible = true; // Now it is showing fade effect and navigating to Login page
    //     });
    //   }
    // );

    void navigateUser() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var status = prefs.getBool('isLoggedIn') ?? false;
      print(status);
      Timer(const Duration(milliseconds: 2000), (){
        setState(() {
          if (status) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(tab: 0)));
          }else {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        });
      });
    }

    new Timer(Duration(milliseconds: 10), () {
      setState(() {
        _isVisible = true; // Now it is showing fade effect and navigating to Login page
      });
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Theme.of(context).colorScheme.secondary, Theme.of(context).primaryColor],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 160.0,
            width: 160.0,
            child: Center(
              child: ClipOval(
                child:
                  Image.asset("assets/images/logo.png"),
              ),
            ),
            // decoration: BoxDecoration(
            //   shape: BoxShape.circle,
            //   color: Color(0xff5885AF),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.3),
            //       blurRadius: 2.0,
            //       offset: Offset(5.0, 3.0),
            //       spreadRadius: 2.0,
            //     )
            //   ]
            // ),
          ),
        ),
      ),
    );
  }
}