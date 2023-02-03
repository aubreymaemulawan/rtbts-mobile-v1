import 'dart:convert';
import 'dart:ui';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/schedule_info_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/globals.dart';
import '../sidebar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_ui/Services/auth_services.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  // TODO: Local Variables
  DateTime _selectedValue = DateTime.now();
  var response, response2;
  bool menuOpen = false;
  double tranx = 0, trany = 0, scale = 1.0;
  String month = "", year = "";

  // TODO: Get Current Date
  Future load_date(BuildContext context) async {
    var dt = DateTime.now();
    year = dt.year.toString();
    String _month = DateFormat("MMMM").format(DateTime.now());
    month = _month.toString();
  }

  // TODO: Fetching Data in the Database
  Future<List<dynamic>> fetch_scheduleInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    http.Response response = await ScheduleServices.schedule(value1, value2, value3!);
    print('>>> For Schedule Page: Schedule List');
    Map responseMap = jsonDecode(response.body);
    return responseMap['assign_sched'];
  }

  // TODO: Fetching Data in the Database
  Future<List<dynamic>> fetch_personnelInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    http.Response response = await ScheduleServices.schedule(value1, value2, value3!);
    print('>>> For Schedule Page: Personnel List');
    Map responseMap = jsonDecode(response.body);
    return responseMap['personnel_info'];
  }

  @override
  void initState() {
    // _SchedulePageState();
    load_date(context);
    response = fetch_scheduleInfo();
    response2 = fetch_personnelInfo();
    super.initState();
  }

  // TODO: Return Screen Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            alignment: Alignment.topCenter,
            color: Color(0xFFF0F0F0),
            height: MediaQuery.of(context).size.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month_rounded, color: Colors.black26),
                    SizedBox(
                      width: 10,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "$month",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF41729F),
                            fontSize: 25,
                          ),
                          children: [
                            TextSpan(
                              text: "  $year",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
                Text(
                  "Today",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF41729F),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 75,
            child: Container(
              height: MediaQuery.of(context).size.height - 160,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 30),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: buildDateColumn()
                    ),
                  Expanded(
                      child: buildTaskListItem()
                    ),
                  SizedBox( height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      );
  }

  FutureBuilder buildTaskListItem() {
    return FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                String dt = (_selectedValue.year.toString()+"-"+_selectedValue.month.toString()+"-"+_selectedValue.day.toString());
                if(dt == snapshot.data[index]['date'].toString()) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 25),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 15,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(5),
                                  )),
                            ),
                            SizedBox(width: 15),
                            Container(
                              width: MediaQuery.of(context).size.width - 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: DateFormat.jm().format(DateFormat("hh:mm:ss").parse(snapshot.data[index]['schedule']['first_trip']))
                                          +" - "+DateFormat.jm().format(DateFormat("hh:mm:ss").parse(snapshot.data[index]['schedule']['last_trip'])), // Time
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    status(snapshot.data[index]['status'].toString()),
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox( height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              var today = new DateTime.now();
                              var dateToday = new DateFormat('yyyy-MM-dd');
                              String formattedDate = dateToday.format(today);
                              if(snapshot.data[index]['date'].toString() != formattedDate){
                                errorSnackBar(context, 'Trip not yet available.');
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleInfoPage(data: snapshot.data[index])));
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Color(0xffA5C9CA).withOpacity(0.5),
                                  border: Border.all(width: 1, color: Color(0xffE0E5F1)),
                                  borderRadius: BorderRadius.circular(20)),
                              margin: EdgeInsets.only(right: 10, left: 30),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data[index]['schedule']['route']['from_to_location'].toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Vice Versa",
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.location_on,size: 20 ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data[index]['bus']['bus_no'].toString()+" - "+busType(snapshot.data[index]['bus']['bus_type'].toString()),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Bus Information",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data[index]['max_trips'].toString()+" max : "+snapshot.data[index]['schedule']['interval_mins'].toString()+" mins",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "Trip Information",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 15,)
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  FutureBuilder(
                                    future: response2,
                                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot2) {
                                      if(snapshot2.hasData){
                                        int index2 = 0, index3 = 0, index4 = 0;
                                        for (int i = 0; i < snapshot2.data.length; i++) {
                                          if(snapshot2.data[i]['id'] == snapshot.data[index]['operator_id']){
                                            index2 = i;
                                          }
                                          if(snapshot2.data[i]['id'] == snapshot.data[index]['conductor_id']){
                                            index3 = i;
                                          }
                                          if(snapshot2.data[i]['id'] == snapshot.data[index]['dispatcher_id']){
                                            index4 = i;
                                          }
                                        }
                                        return Container(
                                          child: Column( children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 9,
                                                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1541647376583-8934aaf3448a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=200&q=80"),),
                                                SizedBox(width: 5),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Text("Operator: ",style: TextStyle(color: Colors.grey, fontSize: 12)),
                                                    SizedBox(width: 10),
                                                    Text(
                                                        snapshot2.data[index2]['name'].toString(),
                                                        style: TextStyle(fontSize: 15)),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 9,
                                                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1541647376583-8934aaf3448a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=200&q=80"),),
                                                SizedBox(width: 5),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Text("Conductor: ",style: TextStyle(color: Colors.grey, fontSize: 12)),
                                                    SizedBox(width: 10),
                                                    Text(snapshot2.data[index3]['name'].toString(),style: TextStyle(fontSize: 15)),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 15),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 9,
                                                  backgroundImage: NetworkImage("https://images.unsplash.com/photo-1541647376583-8934aaf3448a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=200&q=80"),),
                                                SizedBox(width: 5),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Text("Dispatcher: ",style: TextStyle(color: Colors.grey, fontSize: 12)),
                                                    SizedBox(width: 10),
                                                    Text(snapshot2.data[index4]['name'].toString(),style: TextStyle(fontSize: 15)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                          ),
                                        );
                                      }
                                      else{
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },

                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }else{
                  return Container();
                }
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

  Container buildDateColumn() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DatePicker(
            DateTime.now(),
            initialSelectedDate: DateTime.now(),
            selectionColor: Color(0xff41729F),
            onDateChange: (date) {
              setState(() {
                _selectedValue = date;
              });
            },
          ),
        ],
      )
    );
  }

  String busType(String busType) {
    String type = "";
    if(busType == "1"){ type = "AC";}
    else if(busType == "2"){ type = "Non AC";}
    return type;
  }

  String status(String status) {
    String type = "";
    if(status == "1"){ type = "Active";}
    else if(status == "2"){ type = "Not Active";}
    else if(status == "3"){ type = "Cancelled";}
    return type;
  }

}
