import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_ui/Services/auth_services.dart';
import 'package:intl/date_symbol_data_local.dart';

class TripPage extends StatefulWidget {
  const TripPage({Key? key}) : super(key: key);
  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  final _formKey = GlobalKey<FormState>();
  var response;

  // TODO: Fetching Data in the Database
  Future<List<dynamic>> fetch_tripInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    http.Response response = await TripServices.trip(value1, value2, value3!);
    print('>>> For Trip Page');
    Map responseMap = jsonDecode(response.body);
    return responseMap['trip'];
  }

  @override
  void initState() {
    _TripPageState();
    response = fetch_tripInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Records",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      body: Container(
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              children: [
                Expanded(
                  child: buildTripListItem()
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder buildTripListItem() {
    return FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                final String dt = snapshot.data[index]['personnel_schedule']['date']+" 00:00:00";
                final DateTime now = DateTime.parse(dt);
                final String date = DateFormat.yMMMMd('en_US').format(now);
                bool isFirst = true;
                bool isLast = false;
                bool visible = true;
                double pad = 0, pad2 = 0, pad3 = 0;
                int length = 0;
                length = snapshot.data.length - 1;
                String route = "";

                // TODO: For Inverse Route
                if(snapshot.data[index]['inverse'] == 1){
                  String txt = snapshot.data[index]['personnel_schedule']['schedule']['route']['from_to_location'].toString();
                  var parts = txt.split(' - ');
                  route = parts.sublist(1).join(' - ').trim()+" - "+parts[0].trim();
                }
                else{
                  route = snapshot.data[index]['personnel_schedule']['schedule']['route']['from_to_location'].toString();
                }

                // TODO: For Timeline Indicator (if its the end or beginning)
                if(index == 0){
                  pad = 20;
                  pad2 = 20;
                  isFirst = true;
                  isLast = false;
                }
                else if(index == length){
                  isLast = true;
                  pad3 = 60;
                }

                // TODO: For Date Visibility
                if(index !=0 ){
                  if(snapshot.data[index-1]['personnel_schedule']['date'] == snapshot.data[index]['personnel_schedule']['date']){
                    visible = false;
                  }else{
                    visible = true;
                    pad2 = 20;
                  }
                }

                // TODO: For Timeline Visibility (if its the end or beginning base on date)
                if(index != length ){
                  if(snapshot.data[index+1]['personnel_schedule']['date'] != snapshot.data[index]['personnel_schedule']['date']){
                    isLast = true;
                    pad3 = 10;
                  }else{
                    isLast = false;
                  }
                }

                // TODO: For One Data only
                if(snapshot.data.length == 1){
                  isFirst = true;
                  isLast = true;
                }

                return Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, pad, 20, pad3),
                    child: Column(
                      children: [
                        Visibility(
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: pad2),
                            child: Text(
                                '$date',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                          ),
                          visible: visible,),
                        TimelineTile(
                          axis: TimelineAxis.vertical,
                          indicatorStyle: IndicatorStyle(
                            color: Colors.orange,
                            height: 20,
                            width: 15,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 14),
                            indicatorXY: 0,
                          ),
                          isFirst: isFirst,
                          isLast: isLast,
                          afterLineStyle: LineStyle(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          beforeLineStyle: LineStyle(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          alignment: TimelineAlign.manual,
                          lineXY: 0.25,
                          startChild: Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(top: 14),
                            child: RichText(
                              text: TextSpan(
                                  text: DateFormat.jms().format(
                                      DateTime.parse(snapshot.data[index]['created_at']).toLocal()).toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                              ),
                            ),
                          ),
                          endChild: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              // margin: EdgeInsets.only(right: 10, left: 30),
                              padding: EdgeInsets.all(15),
                              // height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Color(0xffA5C9CA).withOpacity(0.5),
                                  border: Border.all(width: 1, color: Color(0xffE0E5F1)),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Trip No. "+snapshot.data[index]['trip_no'].toString()
                                    +" - "+Arrived(snapshot.data[index]['arrived']).toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$route',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Trip End: "+DateFormat.jms().format(
                                                DateTime.parse(snapshot.data[index]['created_at']).toLocal()).toString(),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            snapshot.data[index]['trip_duration'].toString()+" minutes",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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

  String Arrived (int arr) {
    String is_arrived = "";
    if(arr == 1){ is_arrived = "Arrived";}
    else if(arr == 2){ is_arrived = "Cancelled "
        "";}
    return is_arrived;
  }
}


