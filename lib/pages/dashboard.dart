import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/login_page.dart';
import 'package:flutter_login_ui/pages/widgets/header_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../Services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';
import '../sidebar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_ui/Services/auth_services.dart';

import 'notification_info_page.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  String name = "";
  var response;

  // Logout Function
  Future logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    preferences.remove('email');
    preferences.remove('personnel_id');
    successSnackBar(context, 'Logout Successful.');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future fetchDashboardInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    http.Response response = await DashboardServices.dashboard(value1, value2, value3!);
    print('>>> For Dashboard Page');
    Map responseMap = jsonDecode(response.body);
    return responseMap['data'];
    // if (response.statusCode == 200) {
    //   setState(() {
    //     // final user_name = responseMap['user']['name'].toString();
    //     // final n = user_name.split(',');
    //     // final Map<int, String> values = {
    //     //   for (int i = 0; i < n.length; i++)
    //     //     i: n[i]
    //     // };
    //     // name = values[1].toString();
    //     name = responseMap['data']['user']['name'].toString();
    //     // name = value1.toString();
    //     // company = responseMap['company'].toString();
    //     // personnel_no = responseMap['personnel']['personnel_no'].toString();
    //     // trips = responseMap['personnel']['age'].toString();
    //     // age = responseMap['personnel']['age'].toString();
    //     // contact_no = responseMap['personnel']['contact_no'].toString();
    //     // address = responseMap['personnel']['address'].toString();
    //     // last_updated = responseMap['user']['updated_at'].toString();
    //     // if (responseMap['personnel']['user_type'] == 2) {
    //     //   user_type = "Conductor";
    //     // }
    //   });
    // }
  }

  @override
  void initState() {
    _DashboardState();
    response = fetchDashboardInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      ),
      drawer: SideBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: buildUserListItem(),
              ),
            ],
          ),
        ],
      )
    );
  }

  FutureBuilder buildUserListItem() {
    double _headerHeight = 100;
    return FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          final String dt = snapshot.data['reminder']['created_at'];
          final DateTime now = DateTime.parse(dt);
          final String date = DateFormat.yMMMMd('en_US').format(now);
          String user_name = snapshot.data['user']['name'].toString();
          final n = user_name.split(',');
          final Map<int, String> values = {
            for (int i = 0; i < n.length; i++)
              i: n[i]
          };
          name = values[1].toString();
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 35,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    gradient: LinearGradient(
                      colors: [ Theme.of(context).primaryColor,Theme.of(context).colorScheme.secondary,],
                    ),
                  ),
                ),
                Stack(
                    children: [
                      Container(
                          height: _headerHeight,
                          child: HeaderWidget(_headerHeight, false, Icons.house_rounded)
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: RichText(
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text: "Hello, ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 25),
                                            ),
                                            TextSpan(
                                              text: "$name",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 25),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 60,),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(top: 20),
                                        padding: EdgeInsets.fromLTRB(20, 20, 30, 20),
                                        decoration: BoxDecoration(
                                            color: Color(0xff395B64).withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Active Schedules",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17),
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.solidCalendarCheck,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 10,),
                                                Text(
                                                  snapshot.data['count']['count_sched'].toString(),
                                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                                )
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => Home(tab: 1)));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.only(top: 20),
                                                decoration: BoxDecoration(
                                                    color: Color(0xff375BE9),
                                                    borderRadius: BorderRadius.circular(50)),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "More Information ",
                                                      style: TextStyle(color: Colors.white, fontSize: 10),
                                                    ),
                                                    Icon(Icons.arrow_forward, color: Colors.white, size: 18,),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 20),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Color(0xffA5C9CA),
                                                  borderRadius: BorderRadius.circular(15)),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Color(0xff375BE9)),
                                                    child: Center(
                                                      child: Text(
                                                        snapshot.data['count']['count_cancel'].toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w300,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 15),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Cancelled",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold, fontSize: 16),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Trips",
                                                        style: TextStyle(
                                                            fontSize: 13, color: Colors.blueGrey[500]),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Color(0xffA5C9CA),
                                                  borderRadius: BorderRadius.circular(15)),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: Color(0xff375BE9)),
                                                          child: Center(
                                                            child: Text(
                                                              snapshot.data['count']['count_total'].toString(),
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w300,
                                                                  fontSize: 16),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Total",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold, fontSize: 16),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "Trips",
                                                              style: TextStyle(
                                                                  fontSize: 13, color: Colors.blueGrey[500]),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          padding: EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                            color: Colors.blueGrey[100],
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              snapshot.data['count']['count_duration_total'].toString()+" Mins",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold, fontSize: 10),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                "Announcements",
                                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home(tab: 3,)));},
                                                child: Text(
                                                  "See All",
                                                  style: TextStyle(color: Color(0xff6280FF)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationInfoPage(data: snapshot.data['reminder'])));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(width: 2, color: Color(0xffE0E5F1)),
                                                borderRadius: BorderRadius.circular(20)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage("assets/images/dark.jpg"),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        borderRadius: BorderRadius.circular(100),
                                                        border: Border.all(width: 4, color: Colors.white),
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          snapshot.data['reminder']['company']['company_name'].toString(),
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Posted $date",
                                                          style: TextStyle(
                                                            color: Colors.blueGrey[200],
                                                            height: 1.5,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      padding: EdgeInsets.all(7),
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff13C6C2),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: Text(
                                                        receiver(snapshot.data['reminder']['user_type'].toString()),
                                                        style: TextStyle(
                                                            color: Colors.white, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Container(
                                                  child: Text(
                                                    snapshot.data['reminder']['subject'].toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Container(
                                          height: 80,
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Color(0xff6280FF),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Icon(
                                                  FontAwesomeIcons.slackHash,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),

                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Always wear your seatbelts.",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Have a safe trip",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 100)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ])
              ],),
          );
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  String receiver(String userType) {
    String user = '';
    switch (userType){
      case '1': user = "All"; break;
      case '2': user = "Conductor"; break;
      case '3': user = "Dispatcher"; break;
      case '4': user = "Operator"; break;
      case '5': user = "Passengers"; break;
      case '6': user = "Personnel"; break;
    }
    return user;
  }
}

