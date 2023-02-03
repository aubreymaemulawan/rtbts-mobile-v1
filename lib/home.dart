
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/schedule_info_page.dart';
import 'package:flutter_login_ui/pages/account_password_page.dart';
import 'package:flutter_login_ui/pages/dashboard.dart';
import 'package:flutter_login_ui/pages/login_page.dart';
import 'package:flutter_login_ui/pages/notification_page.dart';
import 'package:flutter_login_ui/pages/unused/profile_page.dart';
import 'package:flutter_login_ui/pages/schedule_page.dart';
import 'package:flutter_login_ui/pages/trip_page.dart';
import 'package:flutter_login_ui/pages/account_profile_page.dart';
import 'package:flutter_login_ui/sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_ui/Services/auth_services.dart';

import 'Services/globals.dart';

class Home extends StatefulWidget {
  final int tab;
  const Home ({Key? key, required this.tab}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  String arr = '';
  final List<Widget> screens = [
    Dashboard(),
    SchedulePage(),
    TripPage(),
    NotificationPage(),
    SideBar()
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Dashboard();

  // TODO: Fetching Data in the Database
  fetchStatusInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    http.Response response = await OngoingStatusServices.ongoing(value1, value2, value3!);
    print('>>> For Home Status');
    Map responseMap = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(responseMap['data']['arrived'] == 0){
        setState(() {
          ongoingTripSnackBar(context,
              'Hi',
              responseMap['data']['assign_sched'],
              responseMap['data']['trip'],
              responseMap['data']['bus_status']);
        });
    }
    }
    // return responseMap['data']['arrived'].toString(); //data //trip //status
  }

  @override
  void initState() {
    _HomeState();
    currentTab = widget.tab;
    fetchStatusInfo();
    // if(arr == 0) {
    //
    //   // WidgetsBinding.instance?.addPostFrameCallback((_) =>
    //   //     ongoingTripSnackBar(context, 'Hi'));
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: screens,
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {},
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: homeBottomAppBar()
    );
  }

  Widget homeBottomAppBar(){
    return BottomAppBar(
      // shape: CircularNotchedRectangle(),
      // notchMargin: 10,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard
                MaterialButton(
                  minWidth: 40,
                  onPressed: (){
                    setState(() {
                      currentScreen = Dashboard();
                      currentTab = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.dashboard,
                        color: currentTab == 0 ? Colors.blueGrey : Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,2,0,0),
                        child: Text(
                          "Dashboard",
                          style: TextStyle(
                              color: currentTab == 0 ? Colors.blueGrey : Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Schedule
                MaterialButton(
                  minWidth: 40,
                  onPressed: (){
                    setState(() {
                      currentScreen = SchedulePage();
                      currentTab = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: currentTab == 1 ? Colors.blueGrey : Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Text(
                          "Schedule",
                          style: TextStyle(
                              color: currentTab == 1 ? Colors.blueGrey : Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip
                MaterialButton(
                  minWidth: 40,
                  onPressed: (){
                    setState(() {
                      currentScreen = TripPage();
                      currentTab = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        color: currentTab == 2 ? Colors.blueGrey : Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Text(
                          "My Trips",
                          style: TextStyle(
                              color: currentTab == 2 ? Colors.blueGrey : Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      )

                    ],
                  ),
                ),
                // Notifications
                MaterialButton(
                  minWidth: 40,
                  onPressed: (){
                    setState(() {
                      currentScreen = NotificationPage();
                      currentTab = 3;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications,
                        color: currentTab == 3 ? Colors.blueGrey : Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                        child: Text(
                          "Notifications",
                          style: TextStyle(
                              color: currentTab == 3 ? Colors.blueGrey : Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
