import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import '../sidebar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_ui/Services/auth_services.dart';

import 'notification_info_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var response;

  // TODO: Fetching Data in the Database
  Future<List<dynamic>> fetchNotificationInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    http.Response response = await NotificationServices.notification(value1, value2, value3!);
    print('>>> For Notification Page');
    Map responseMap = jsonDecode(response.body);
    return responseMap['reminder'];
  }

  // TODO:
  @override
  void initState() {
    _NotificationPageState();
    response = fetchNotificationInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Notifications",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                child: Container(
                    padding: const EdgeInsets.all(15),
                  alignment: Alignment.topCenter,
                  child: buildNotificationListItem()
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  FutureBuilder buildNotificationListItem() {
    return FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                final String dt = snapshot.data[index]['created_at'];
                final DateTime now = DateTime.parse(dt);
                final String day = DateFormat.yMd().format(now);
                final String time = DateFormat.jm().format(now);
                final date = day + " " + time;
                return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationInfoPage(data: snapshot.data[index])));
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFF1F1F1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 2.0,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Text(
                                              'Message',
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black45)),
                                        ),
                                        Spacer(),
                                        Container(
                                          child: Text(
                                              '$date',
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black45)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 12),
                                        child: Container(
                                          padding: EdgeInsets.all(25),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage("assets/images/dark.jpg"),
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius: BorderRadius.circular(100),
                                            border: Border.all(width: 4, color: Colors.white),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top:5, bottom: 12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                    snapshot.data[index]['subject'].toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
                                              ),
                                              Container(
                                                child: Text(
                                                  snapshot.data[index]['message'].toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 12,  color: Colors.black45),

                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],

                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 12,)
                    ],
                  );
              }
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
}
