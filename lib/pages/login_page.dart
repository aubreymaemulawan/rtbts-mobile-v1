import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/success_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'unused/forgot_password_page.dart';
import 'widgets/header_widget.dart';
import 'dart:convert';
import 'package:flutter_login_ui/Services/auth_services.dart';
import 'package:flutter_login_ui/Services/globals.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}): super(key:key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  String _email = "";
  String _password = "";
  double _headerHeight = 280;
  Key _formKey = GlobalKey<FormState>();

  // Login Function
  loginPressed() async {
    if(_email.isNotEmpty && _password.isNotEmpty) {
      http.Response response = await LoginServices.login(_email, _password);
      print('>>> For Login Page');
      Map responseMap = jsonDecode(response.body);
      if(response.statusCode == 200) {
        successSnackBar(context, 'Login Successful.');
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setBool("isLoggedIn", true);
        preferences.setString('email', responseMap['user']['email']);
        preferences.setString('password', _password);
        preferences.setInt('personnel_id', responseMap['user']['personnel_id']);
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context) =>
            SuccessPage(text1: "Welcome ",text2: responseMap['user']['name'].toString(),text3: "Authenticated Successfully",text4: "Get Started",)));
      }else{
        errorSnackBar(context, responseMap.values.first);
      }
    }else{
      errorSnackBar(context, 'Enter all required fields.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
        },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true, Icons.train),
              ),
              SafeArea(
                child: Container( 
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),// This will be the login form
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,//Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment.center,//Center Row contents vertically,
                        children: [
                          Text(
                            'R T',
                            style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.grey[700], fontSize: 50, fontWeight: FontWeight.w500),
                          )),
                          Text(
                            ' B ',
                            style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.blueGrey[400], fontSize: 50, fontWeight: FontWeight.w500),
                          )),
                          Text(
                            'T S',
                            style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.grey[700], fontSize: 50, fontWeight: FontWeight.w500),
                          )),
                        ],
                      ),
                      Text(
                        'Please login to your account.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                        key: _formKey,
                          child: Column(
                            children: [
                              // Email
                              Container(
                                child: TextField(
                                  decoration: ThemeHelper().textInputDecoration('User Name', 'Enter your user name'),
                                  onChanged: (value){
                                    _email = value;
                                  }
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              // Password
                              Container(
                                child: TextField(
                                  obscureText: true,
                                  decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                                  onChanged: (value){
                                    _password = value;
                                  }
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 15.0),
                              // Forgot Password
                              Container(
                                margin: EdgeInsets.fromLTRB(10,0,10,30),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), );
                                  },
                                  child: Text( "Forgot your password?", style: TextStyle( color: Colors.grey, ),
                                  ),
                                ),
                              ),
                              // Log In Button
                              Container(
                                decoration: ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text('Login'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                  ),
                                  onPressed: () => {
                                    // Navigator.pop(context),
                                    loginPressed() }
                                  //     (){
                                  //   //After successful login we will redirect to profile page. Let's create profile page now
                                  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home())),
                                )),
                            ],
                          )
                      ),
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}