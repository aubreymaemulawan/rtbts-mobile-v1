
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/success_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/auth_services.dart';
import '../Services/globals.dart';
import '../common/theme_helper.dart';
import 'package:http/http.dart' as http;import '../Services/auth_services.dart';
import '../Services/globals.dart';
import '../common/theme_helper.dart';
import 'package:http/http.dart' as http;
import '../home.dart';
import 'account_page.dart';
import 'unused/forgot_password_verification_page.dart';
import 'login_page.dart';
import 'widgets/header_widget.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool fill = true, _isObscureCurrent = true, _isObscureNew = true, _isObscureRetype = true;
  TextEditingController _currentController = TextEditingController();
  TextEditingController _newController = TextEditingController();
  TextEditingController _retypeController = TextEditingController();

  updatePassword() async {
    if(_currentController.text.isNotEmpty && _newController.text.isNotEmpty
        && _retypeController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email').toString();
      final password = prefs.getString('password').toString();
      final personnel_id = prefs.getInt('personnel_id');
      http.Response response = await UpdatePasswordServices.updatePassword(
        email,
        password,
        personnel_id!,
        _currentController.text,
        _newController.text,
        _retypeController.text
      );
      print('>>> For Account Password Page');
      Map responseMap = jsonDecode(response.body);
      if(response.statusCode == 200) {
        prefs.clear();
        prefs.remove('email');
        prefs.setBool("isLoggedIn", true);
        prefs.setString('email', email);
        prefs.setString('password', _newController.text);
        prefs.setInt('personnel_id', personnel_id);
        Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) =>
            SuccessPage(text1: "Password ",text2: "Updated",text3: "Successfully updated in the database",text4: "PROFILE",)),
        );
      }else{
        errorSnackBar(context, responseMap.values.first);
      }
    }else{
      errorSnackBar(context, 'Enter all required fields.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 100;
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Update Password",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.white),
          leading: Container(
            child: Row(
              children: [
                IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Icon(Icons.arrow_back),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => AccountPage())
                      );
                    },
                    color: Colors.white)
              ],
            ),
          ),
          flexibleSpace:Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).accentColor,]
                )
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () => updatePassword(),
              child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                child: buildTextField()
              )
            ],
          ),
        )
    );
  }

  Widget buildTextField() {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 0, 25, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create New Password',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFF41729F)
                  ),
                  // textAlign: TextAlign.center,
                ),
                SizedBox(height: 12,),
                Text('Your new password must be different from your previous used passwords.',
                  style: TextStyle(
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Text("Current Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 180,
                      child: TextField(
                        obscureText: _isObscureCurrent,
                        controller: _currentController,
                        decoration:
                        InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: fill? Color(0xff41729F):Colors.grey.shade400.withOpacity(0.4),width: 1)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400.withOpacity(0.4))),
                          suffix: InkWell(
                            onTap: _togglePasswordViewCurrent,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Icon( !_isObscureCurrent ? Icons.visibility: Icons.visibility_off, color: Color(0XFF41729F),size: 20,),
                            ),
                          ),
                        ),
                        // InputDecoration(
                        //   // !fill ? Color(0xffEBEBE4): Colors.white,
                        //     contentPadding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                        //     focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: fill? Color(0xff41729F):Colors.grey.shade400.withOpacity(0.4),width: 1)),
                        //     enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400.withOpacity(0.4))),
                        //
                        //     suffixIcon: IconButton(
                        //         icon: _isObscure ? Icon(Icons.visibility): Icon(Icons.visibility),
                        //         onPressed: () {
                        //           setState(() {
                        //             _isObscure = !_isObscure;
                        //           });
                        //         })),
                        //   errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                        //   focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                        // )
                        // ThemeHelper().textInput3Decoration(true,false),
                        // onChanged: (value){
                        //   _password = value;
                        // }
                      ),)
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Text("New Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 180,
                      child: TextField(
                        obscureText: _isObscureNew,
                        controller: _newController,
                        decoration:
                        InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: fill? Color(0xff41729F):Colors.grey.shade400.withOpacity(0.4),width: 1)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400.withOpacity(0.4))),
                          suffix: InkWell(
                            onTap: _togglePasswordViewNew,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Icon( !_isObscureNew ? Icons.visibility: Icons.visibility_off, color: Color(0XFF41729F),size: 20,),
                            ),
                          ),
                        ),


                        // InputDecoration(
                        //   // !fill ? Color(0xffEBEBE4): Colors.white,
                        //     contentPadding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                        //     focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: fill? Color(0xff41729F):Colors.grey.shade400.withOpacity(0.4),width: 1)),
                        //     enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400.withOpacity(0.4))),
                        //
                        //     suffixIcon: IconButton(
                        //         icon: _isObscure ? Icon(Icons.visibility): Icon(Icons.visibility),
                        //         onPressed: () {
                        //           setState(() {
                        //             _isObscure = !_isObscure;
                        //           });
                        //         })),
                        //   errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                        //   focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                        // )
                        // ThemeHelper().textInput3Decoration(true,false),
                        // onChanged: (value){
                        //   _password = value;
                        // }
                      ),)
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Text("Retype Password", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 180,
                      child: TextField(
                        obscureText: _isObscureRetype,
                        controller: _retypeController,
                        decoration:
                        InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: fill? Color(0xff41729F):Colors.grey.shade400.withOpacity(0.4),width: 1)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400.withOpacity(0.4))),
                          suffix: InkWell(
                          onTap: _togglePasswordViewRetype,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Icon( !_isObscureRetype ? Icons.visibility: Icons.visibility_off, color: Color(0XFF41729F),size: 20,),
                          ),
                        ),
                      ),


                        // InputDecoration(
                        //   // !fill ? Color(0xffEBEBE4): Colors.white,
                        //     contentPadding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                        //     focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: fill? Color(0xff41729F):Colors.grey.shade400.withOpacity(0.4),width: 1)),
                        //     enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400.withOpacity(0.4))),
                        //
                        //     suffixIcon: IconButton(
                        //         icon: _isObscure ? Icon(Icons.visibility): Icon(Icons.visibility),
                        //         onPressed: () {
                        //           setState(() {
                        //             _isObscure = !_isObscure;
                        //           });
                        //         })),
                        //   errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                        //   focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                        // )
                        // ThemeHelper().textInput3Decoration(true,false),
                        // onChanged: (value){
                        //   _password = value;
                        // }
                      ),)
                  ],
                ),
                SizedBox(height: 30.0),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _togglePasswordViewCurrent() {
    setState(() {
      _isObscureCurrent = !_isObscureCurrent;
    });
  }

  void _togglePasswordViewNew() {
    setState(() {
      _isObscureNew = !_isObscureNew;
    });
  }

  void _togglePasswordViewRetype() {
    setState(() {
      _isObscureRetype = !_isObscureRetype;
    });
  }
}
