import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/Services/globals.dart';
import 'package:flutter_login_ui/pages/account_password_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../home.dart';
import 'dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_ui/Services/auth_services.dart';

class ScheduleTripPage extends StatefulWidget {
  final dynamic data;
  final dynamic trip;
  final int status;
  ScheduleTripPage({Key? key, required this.data, required this.trip, required this.status}) : super(key: key);
  @override
  _ScheduleTripPageState createState() => _ScheduleTripPageState();
}

class _ScheduleTripPageState extends State<ScheduleTripPage> {
  bool clicked = false;
  PanelController _panelController = PanelController();
  bool _isOpen = false;
  var response;
  double lat1 = 0, lat2 = 0, lng1 = 0, lng2 = 0;

  // TODO: Fetching Data in the Database
  fetchPositionInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    http.Response response = await PositionServices.position(
        value1,
        value2,
        value3!,
        widget.trip['id'],
    );
    print('>>> For Schedule Trip Page : Fetch Position');
    Map responseMap = jsonDecode(response.body);
    if(response.statusCode == 200){
      setState(() {
        lat1 = double.parse(responseMap['position']['lat1']);
        lng1 = double.parse(responseMap['position']['lng1']);
        lat2 = double.parse(responseMap['position']['lat2']);
        lng2 = double.parse(responseMap['position']['lng2']);
      });
    }
  }

  // TODO: Sending Data in the Database
  sendStatusInfo(int bus_status) async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    http.Response response = await UpdateStatusServices.updateStatus(
        value1,
        value2,
        value3!,
        widget.data['id'],
        bus_status,
        widget.trip['id'],
        widget.data['max_trips']
    );
    print('>>> For Schedule Trip Page : Send Status');
    if(bus_status == 4 || bus_status == 5){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
        successTopSnackBar(context, busStatus(bus_status), 250);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home(tab: 2,)));
    }else{
      successTopSnackBar(context, busStatus(bus_status), 160);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>
          ScheduleTripPage(data: widget.data, trip: widget.trip, status: bus_status)
      ));
    }
  }

  // TODO: Fetching Data in the Database
  Future<List<dynamic>> fetchStatusInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    http.Response response = await StatusServices.status(value1, value2, value3!, widget.trip['id']);
    print('>>> For Schedule Trip Page : Status Logs');
    Map responseMap = jsonDecode(response.body);
    return responseMap['status'];
  }

  // TODO: Logout Dialog Confirmation
  Future<void> statusConfirm(BuildContext context, int bus_status) async {
    String mess = '';
    if(bus_status == 4){
      mess = 'to cancel trip?';
    }else if(bus_status == 5){
      mess = 'trip has arrived?';
    }
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: Text('Are you sure '+mess),
            actions: [
              TextButton(
                  onPressed: () {
                    sendStatusInfo(bus_status);
                  },
                  child: const Text('Yes', style: TextStyle(color: Color(0xff5885AF)),)
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')
              )
            ],
          );
        });
  }

  @override
  void initState() {
    _ScheduleTripPageState();
    response = fetchStatusInfo();
    fetchPositionInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var marker = <Marker>[];
    marker = [
      // TODO: From location
      Marker(
          point: LatLng(lat1, lng1),
          builder: (ctx) => Icon(Icons.location_on, color: Colors.red,size: 40,)
      ),
      // TODO: To location
      Marker(
          point: LatLng(lat2, lng2),
          builder: (context) => Icon(Icons.location_on, color: Colors.blue,size: 40,)
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Ongoing Trip",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          IconButton(
            icon: Icon(Icons.close,color: Colors.white,),
            color: Colors.white,
            onPressed: () => Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => Home(tab: 1)))
            ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.8,
            child: Container(
              child: Column(
                children: [
                  Flexible(
                      child: FlutterMap(
                        options: MapOptions(
                          center: LatLng(8.489868964446472, 124.65757082549597),
                          zoom: 13
                        ),
                        layers: [
                          TileLayerOptions(
                            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a','b','c'],
                          ),
                          MarkerLayerOptions(
                            rotate: true,
                            markers: marker,
                          )
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.2,
            child: Container(
              color: Colors.white,
            ),
          ),
          SlidingUpPanel(
            controller: _panelController,
            backdropEnabled: true,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              topLeft: Radius.circular(32),
            ),
            minHeight: MediaQuery.of(context).size.height * 0.20,
            maxHeight: MediaQuery.of(context).size.height * 0.80,
            panelBuilder: (ScrollController controller) =>
                _panelBody(controller),
            onPanelSlide: (value) {
              if (value >= 0.2) {
                if (!_isOpen) {
                  setState(() {
                    _isOpen = true;
                  });
                }
              }
            },
            onPanelClosed: () {
              setState(() {
                _isOpen = false;
              });
            },
          ),
        ],
      ),

    );
  }

  /// Panel Body
  Column _panelBody(ScrollController controller) {
    double hPadding = 15;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: hPadding),
          height: MediaQuery.of(context).size.height * 0.20,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Trip No. "+widget.trip['trip_no'].toString()+" ("+busStatus(widget.status)+")",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 23,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    textInverse(widget.data['schedule']['route']['from_to_location']),
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Visibility(
                    visible: !_isOpen,
                    child: Expanded(
                      child: RaisedButton(
                        onPressed: () => _panelController.open(),
                        color: Color(0xff41729F),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          'SET STATUS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.status == 1 ? null : () {
                        sendStatusInfo(1);
                      },
                      child: Text("Passenger Load".toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 16),),
                      style: ElevatedButton.styleFrom(
                          elevation: 3,
                          primary: Colors.orange,
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.status == 2 ? null : () {
                        sendStatusInfo(2);
                      },
                      child: Text("Break".toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 16),),
                      style: ElevatedButton.styleFrom(
                          elevation: 3,
                          primary: Colors.blueGrey,
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.status == 3 ? null : () {
                        sendStatusInfo(3);
                      },
                      child: Text("Departed".toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 16,),),
                      style: ElevatedButton.styleFrom(
                          elevation: 3,
                          primary: Colors.blue,
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.status == 4 ? null : () {
                        statusConfirm(context, 4);
                      },
                      child: Text("Cancel Trip".toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 16),),
                      style: ElevatedButton.styleFrom(
                          elevation: 3,                        primary: Colors.red,
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.status == 5 ? null : () {
                    statusConfirm(context, 5);
                  },
                  child: Text("Arrived".toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 16),),
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                      primary: Colors.green.shade400,
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Container(
            height: 1,
            // color: Colors.grey.shade400.withOpacity(0.8),
            decoration: BoxDecoration(
              color: Colors.grey.shade400.withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          alignment: Alignment.topLeft,
          child: Text('Trip Status Logs',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18
            ),
          ),
        ),
        SizedBox(height: 20,),
        Expanded(child: buildStatusListItem())
      ],
    );
  }

  FutureBuilder buildStatusListItem() {
    return FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                final String dt = snapshot.data[index]['created_at'];
                final DateTime now = DateTime.parse(dt);
                final String day = DateFormat.yMMMMd().format(now);
                final String time = DateFormat.jm().format(now);
                final date = day + " " + time;
              return Column(
                children: [
                  Container(
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
                                        text: "Updated: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '$date',
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                            ),
                                          )
                                        ]),
                                  ),
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
                                  Row(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.info, size: 20),
                                          SizedBox(width: 5),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Trip No : ",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                widget.trip['trip_no'].toString(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.check_circle,size: 20),
                                          SizedBox(width: 5),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Status : ",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                busStatus(snapshot.data[index]['bus_status']),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on,size: 20),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child:
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Location : ",
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              snapshot.data[index]['latitude']+' - '+snapshot.data[index]['longitude'],
                                              maxLines: 2,
                                              softWrap: false,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
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

  String textInverse(String route) {
    String txt = "";
    if(widget.trip['inverse'] == 1){
      var parts = route.split(' - ');
      txt = parts.sublist(1).join(' - ').trim()+" - "+parts[0].trim();
    }else if(widget.trip['inverse'] == 0){
      txt = route;
    }
    return txt;
  }

  String busStatus(int busStatus) {
    String stats = '';
    if(busStatus == 1){
      stats = 'Passenger Load';
    }else if(busStatus == 2){
      stats = 'Break';
    }else if(busStatus == 3){
      stats = 'Departed';
    }else if(busStatus == 4){
      stats = 'Cancelled';
    }else if(busStatus == 5){
      stats = 'Arrived';
    }else{
      stats = 'No Status';
    }
    return stats;
  }

}


