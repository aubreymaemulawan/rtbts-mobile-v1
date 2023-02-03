import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Services/globals.dart';
import 'menu_item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_ui/Services/auth_services.dart';

class SideBar extends StatefulWidget {
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  // TODO: Local Variables
  var response;

  // TODO: Logout Function
  Future logOut(BuildContext context)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    preferences.remove('email');
    successSnackBar(context, 'Logout Successful.');
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  // TODO: Fetching Data in the Database
  Future fetch_userInfo(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    http.Response response = await UserServices.user(value1, value2, value3!);
    print('>>> For Sidebar Page');
    Map responseMap = jsonDecode(response.body);
    return responseMap['user'];
  }

  // TODO: Initial State
  @override
  void initState() {
    _SideBarState();
    super.initState();
    response = fetch_userInfo(context);
  }

  // TODO: Return Screen Widget
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Conductor Panel",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.white),
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
            Padding(
               padding: const EdgeInsets.all(8.0),
               child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () =>
                    Navigator.pop(context),
            ),
             ),
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: Container(
                                padding: EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/user.png"),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(width: 4, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                                  ],
                                ),
                                // child: Icon(Icons.person, size: 30, color: Colors.grey.shade300,),
                              ),
                            ),
                            FutureBuilder(
                              future: response,
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                if(snapshot.hasData){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Text(snapshot.data['name'].toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54)),
                                      ),
                                      Text(UserType(snapshot.data['user_type']).toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff41729F))),
                                    ],
                                  );
                                }
                                else{
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 0,),
                    Column(
                      children: [
                        MenuItem(title: 'Go to Website',icon: Icons.exit_to_app_rounded,num: 1,),
                        MenuItem(title: 'Profile Settings',icon: Icons.person_add_alt_1,num: 2,),
                        MenuItem(title: 'Logout',icon: Icons.logout_rounded,num: 3,),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // TODO: Convert User type Integer
  String UserType(int type){
    String user_type = "";
    if(type == 2){user_type = "Conductor";}
    return user_type;
  }

}
