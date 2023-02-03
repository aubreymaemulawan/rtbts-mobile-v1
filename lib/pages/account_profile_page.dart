import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/pages/success_screen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/auth_services.dart';
import '../Services/globals.dart';
import '../common/theme_helper.dart';
import 'package:http/http.dart' as http;

import 'account_page.dart';

class UpdateProfilePage extends StatefulWidget {
  final dynamic data;
  UpdateProfilePage({Key? key, required this.data}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _pnoController = TextEditingController();
  TextEditingController _usertypeController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _profilePictureController = TextEditingController();

  updateProfile() async {
    if(_ageController.text.isNotEmpty && _contactController.text.isNotEmpty
        && _addressController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email').toString();
      final password = prefs.getString('password').toString();
      final personnel_id = prefs.getInt('personnel_id');
      http.Response response = await UpdateProfileServices.updateProfile(
          email,
          password,
          personnel_id!,
          int.parse(_ageController.text),
          int.parse(_contactController.text),
          _addressController.text,
          _profilePictureController.text,
      );
      print('>>> For Account Profile Page');
      Map responseMap = jsonDecode(response.body);
      if(response.statusCode == 200) {
        Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) =>
            SuccessPage(text1: "Profile ",text2: "Updated",text3: "Successfully updated in the database",text4: "PROFILE",)),
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
    _nameController.text = widget.data['name'].toString();
    _usernameController.text = widget.data['email'].toString();
    _pnoController.text = widget.data['personnel']['personnel_no'].toString();
    _usertypeController.text = userType(widget.data['user_type']).toString()+" - "+widget.data['personnel']['company']['company_name'].toString();
    _ageController.text = widget.data['personnel']['age'].toString();
    _contactController.text = widget.data['personnel']['contact_no'].toString();
    _addressController.text = widget.data['personnel']['address'].toString();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Update Profile",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => AccountPage()));
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
              onPressed: () => updateProfile(),
              child: Text("Save",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Center(
                child: Stack(
                  children: [
                    buildImage(),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {},
                child: Text("Change profile picture", style: TextStyle(color: Colors.blue, fontSize: 12),)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 1,
                color: Colors.grey.shade400.withOpacity(0.3),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: buildTextField()
                ),
              ),
            ),
          ],
        ),
    );
  }

  // TODO: Convert User Type
  String userType(int type){
    String user = "";
    if(type == 2){user = "Conductor";}
    return user;
  }

  Widget buildTextField() {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 0, 25, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          // SizedBox(height: 20.0),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text("Name", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 200,
                      child: TextField(
                        controller: _nameController,
                        readOnly: true,
                        style: TextStyle(color: Colors.black54),
                        decoration: ThemeHelper().textInput2Decoration(false),
                        // onChanged: (value){
                        //   _password = value;
                        // }
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Text("Username", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 200,
                      child: TextField(
                        controller: _usernameController,
                        style: TextStyle(color: Colors.black54),
                        readOnly: true,
                        decoration: ThemeHelper().textInput2Decoration(false),
                        // onChanged: (value){
                        //   _password = value;
                        // }
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Text("PNO", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 200,
                      child: TextField(
                        controller: _pnoController,
                        style: TextStyle(color: Colors.black54),
                        readOnly: true,
                        decoration: ThemeHelper().textInput2Decoration(false),
                        // onChanged: (value){
                        //   _password = value;
                        // }
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Text("User Type", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 200,
                      child: TextField(
                        controller: _usertypeController,
                        style: TextStyle(color: Colors.black54),
                        readOnly: true,
                        decoration: ThemeHelper().textInput2Decoration(false),
                        // onChanged: (value){
                        //   _password = value;
                        // }
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Text("Age", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 200,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: _ageController,
                        readOnly: false,
                        decoration: ThemeHelper().textInput2Decoration(true),
                        // onChanged: (value){
                        //   _password = value;
                        // }
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Text("Contact No.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 200,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: _contactController,
                        readOnly: false,
                        decoration: ThemeHelper().textInput2Decoration(true),
                        // onChanged: (value){
                        //   _password = value;
                        // }
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Text("Address", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 200,
                      child: TextField(
                        controller: _addressController,
                        readOnly: false,
                        decoration: ThemeHelper().textInput2Decoration(true),
                        // onChanged: (value){
                        //   _password = value;
                        // }
                      ),
                    ),
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

  Widget buildImage() {
    final image = AssetImage("assets/images/user.png");
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.grey.shade400.withOpacity(0.4), width: 1),
      ),
      child: ClipOval(
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: image,
            fit: BoxFit.fill,
            width: 100,
            height: 100,
            child: InkWell(onTap: (){}),
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon() => buildCircle(
    all: 5,
    border: BoxDecoration(
      color: Color(0XFF274472),
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: buildCircle(
      border: BoxDecoration(
        color: Color(0XFF274472),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Color(0XFF274472)
        ),
      ),
      all: 3,
      child: Icon(Icons.edit,
        color: Colors.white,
        size: 15,
      ),
    ),
  );

  Widget buildCircle({
    required Decoration border,
    required Widget child,
    required double all,
  }) =>
      ClipOval(
        child: Container(
          decoration: border,
          padding: EdgeInsets.all(all),
          child: child,
        ),
      );
}



