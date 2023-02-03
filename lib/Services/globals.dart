import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/schedule_trip_page.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// For emulator http://10.0.2.2:8000/api/
// For localhost http://localhost:8000/api/
// For webserver https://rtbts-ph.000webhostapp(.)com/api
// For real device testing http://192.168.83.1/api/
// php artisan serve --host 0.0.0.0 --port 80

const String baseURL = "http://10.0.2.2:8000/api/"; //emulator localhost
const Map<String, String> headers = {"Content-Type": "application/json", "Accept":"application/json"};

// Error Message
errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.red,
    content: Text(text),
    duration: const Duration(seconds: 1),
  ));
}

// Success Message
successSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.green,
    content: Text(text),
    duration: const Duration(seconds: 1),
  ));
}

// Success Status Top Message
successTopSnackBar(BuildContext context, String status, double bottom) {
  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    content: Container(
      height: 30,
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white,),
          SizedBox(width: 10,),
          Text('Status updated to '+status.toUpperCase()+'.',
            style: TextStyle(),
          ),
        ],
      ),
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.green,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - bottom,
        right: 20,
        left: 20),
  ));
}


// Success Message
ongoingTripSnackBar(BuildContext context, String text, dynamic data, dynamic trip, int status) {
  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    backgroundColor: Color(0xff41729F),
    content: Container(
      height: 55,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              ScheduleTripPage(data: data, trip: trip, status: status)));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Image(
                    image: AssetImage('assets/images/circle.gif'),
                    height: 30,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Trip No. "+trip['trip_no'].toString()+" ("+busStatus(status)+")",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        textInverse(data['schedule']['route']['from_to_location'], trip['inverse']),
                        style: TextStyle(
                          color: Colors.grey.shade200,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 30,)
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    // elevation: 5,
    dismissDirection: DismissDirection.none,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    // padding: EdgeInsets.all(25),
    // behavior: SnackBarBehavior.floating,
    duration: const Duration(days: 365),
  ));
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

String textInverse(String route, int inverse) {
  String txt = "";
  if(inverse == 1){
    var parts = route.split(' - ');
    txt = parts.sublist(1).join(' - ').trim()+" - "+parts[0].trim();
  }else if(inverse == 0){
    txt = route;
  }
  return txt;
}

