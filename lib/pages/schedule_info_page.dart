import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/schedule_trip_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../Services/globals.dart';
import '../common/theme_helper.dart';
import '../home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_ui/Services/auth_services.dart';

class ScheduleInfoPage extends StatefulWidget {
  final dynamic data;
  ScheduleInfoPage({Key? key, required this.data}) : super(key: key);
  @override
  State<ScheduleInfoPage> createState() => _ScheduleInfoPageState();
}

class _ScheduleInfoPageState extends State<ScheduleInfoPage> {
  final _formKey = GlobalKey<FormState>();
  var response;
  int trip_id = 0;
  int stats = 0;
  // bool dateToday = true;
  TextEditingController _routeController = TextEditingController();
  TextEditingController _busController = TextEditingController();
  TextEditingController _maxTripsController = TextEditingController();
  TextEditingController _firstTripController = TextEditingController();
  TextEditingController _lastTripController = TextEditingController();
  TextEditingController _intervalMinsController = TextEditingController();
  TextEditingController _cancelledController = TextEditingController();

  // TODO: Sending Data in the Database
  createTripInfo(dynamic trip, int inverse) async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    if(trip['trip'] == null){
      trip_id = 0;
    }else{
      trip_id = trip['trip']['id'];
    }
    http.Response response = await CreateTripServices.createTrip(
        value1,
        value2,
        value3!,
        widget.data['id'],
        trip_id,
        trip['trip_cnt'],
        trip['ongoing_cnt'],
        widget.data['max_trips'],
        inverse
    );
    print('>>> For Schedule Info Page : Send Data');
    Map responseMap = jsonDecode(response.body);
    if(responseMap['data']['trip_status'] == null){
      stats = 0;
    }else{
      stats = responseMap['data']['trip_status'];
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleTripPage(
      data: widget.data,
      trip: responseMap['data']['trip'],
      status: stats,
    )
    ));
  }

  // TODO: Logout Dialog Confirmation
  Future<void> routeInverse(dynamic trip) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return SimpleDialog(
            title:const Text('Select Route'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  createTripInfo(trip, 0);
                },
                child: Text(widget.data['schedule']['route']['from_to_location'].toString()),
              ),
              SimpleDialogOption(
                onPressed: () {
                  createTripInfo(trip, 1);
                },
                child: Text( textInverse(widget.data['schedule']['route']['from_to_location'].toString())
                ),
              ),
            ],
          );
        });
  }

  // TODO: Fetching Data in the Database
  Future fetchTripScheduleInfo(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    http.Response response = await TripScheduleServices.tripSchedule(value1, value2, value3!, widget.data['id'], widget.data['max_trips']);
    print('>>> For Schedule Info Page : Fetch Data');
    Map responseMap = jsonDecode(response.body);
    return responseMap['data'];
  }

  // TODO: Declare Initial State of App
  @override
  void initState() {
    _ScheduleInfoPageState();
    response = fetchTripScheduleInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        leading: Container(
          child: Row(
            children: [
              IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Icon(Icons.arrow_back),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => Home(tab:1)));
                  },
                  color: Colors.white)
            ],
          ),
        ),
      ),
      body: Container(
        child: buildTripListItem(),
      )
    );
  }

  FutureBuilder buildTripListItem() {
    return FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          final String dt = widget.data['date']+" 00:00:00";
          final DateTime now = DateTime.parse(dt);
          final String date = DateFormat.yMMMMd('en_US').format(now);
          final String status = scheduleStatus(widget.data['status'].toString());
          var today = new DateTime.now();
          var dateToday = new DateFormat('yyyy-MM-dd');
          String formattedDate = dateToday.format(today);
          return Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 2, color: Color(0xffE0E5F1)),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Schedule Information",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "$date",
                                style: TextStyle(
                                  color: Colors.blueGrey[200],
                                  height: 1.5,
                                ),
                              )
                            ],
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: widget.data['status'] == 1 ? Colors.green: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "$status",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      SafeArea(child: buildTextField(snapshot.data['trip_cnt'], snapshot.data['cancelled_cnt'])),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: dateNow(
                            widget.data['date'],
                            formattedDate,
                            snapshot.data['trip_cnt']) ? () {
                          if(snapshot.data['ongoing_cnt'] == 0){
                            routeInverse(snapshot.data);
                          }else{
                            createTripInfo(snapshot.data, 2);
                          }

                          // createTripInfo(snapshot.data);
                        } : null ,
                        style: ElevatedButton.styleFrom(
                          primary: snapshot.data['ongoing_cnt'] == 1 ? Colors.red:Colors.green,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data['title'].toString().toUpperCase(),
                              style: TextStyle(fontSize: 16,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Home(tab: 2)));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          side: BorderSide(color: Color(0xff41729F)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.eye,
                              color: Colors.blueGrey[100],
                              size: 20,
                            ),
                            SizedBox(width: 10,),
                            Text(
                              "View Trips".toUpperCase(),
                              style: TextStyle(fontSize: 16,
                                  color: Color(0xff41729F)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
    );
  }

  bool dateNow(String date, String today, int trip_cnt){
    bool isToday = true;
    if(trip_cnt == widget.data['max_trips'] || widget.data['status'] == 2){
      isToday = false;
    }else{
      if(date == today){
        isToday = true;
      }else{
        isToday = false;
      }
    }
    return isToday;
  }

  Widget buildTextField(int trip_cnt, int cancelled_cnt) {
    _routeController.text = widget.data['schedule']['route']['from_to_location'];
    _busController.text = widget.data['bus']['bus_no'].toString()+" - "+busType(widget.data['bus']['bus_type'].toString());
    _maxTripsController.text = trip_cnt.toString()+" / "+widget.data['max_trips'].toString();
    _firstTripController.text = DateFormat.jm().format(DateFormat("hh:mm:ss").parse(widget.data['schedule']['first_trip']));
    _lastTripController.text = DateFormat.jm().format(DateFormat("hh:mm:ss").parse(widget.data['schedule']['last_trip']));
    _intervalMinsController.text = widget.data['schedule']['interval_mins'].toString()+" mins";
    _cancelledController.text = cancelled_cnt.toString();
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 25, 10),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text("Route", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 180,
                      child: TextField(
                        controller: _routeController,
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
                    Text("Bus", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 180,
                      child: TextField(
                        controller: _busController,
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
                    Text("First Trip", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 180,
                      child: TextField(
                        controller: _firstTripController,
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
                    Text("Last Trip", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 180,
                      child: TextField(
                        controller: _lastTripController,
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
                    Text("Interval", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 180,
                      child: TextField(
                        controller: _intervalMinsController,
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
                    Text("Trips", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 180,
                      child: TextField(
                        controller: _maxTripsController,
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
                    Text("Cancelled", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                    Spacer(),
                    Container(
                      width: 180,
                      child: TextField(
                        controller: _cancelledController,
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
              ],
            ),
          )
        ],
      ),
    );
  }

  String busType(String bustype) {
    String type = "";
    if(bustype == "1"){ type = "AC";}
    else if(bustype == "2"){ type = "Non AC";}
    return type;
  }

  String scheduleStatus(String status) {
    String type = "";
    if(status == "1"){ type = "Active";}
    else if(status == "2"){ type = "Not Active";}
    else if(status == "3"){ type = "Cancelled";}
    return type;
  }

  String textInverse(String route) {
    String txt = "";
    var parts = route.split(' - ');
    txt = parts.sublist(1).join(' - ').trim()+" - "+parts[0].trim();
    return txt;
  }
}





