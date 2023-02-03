import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationInfoPage extends StatefulWidget {
  final dynamic data;
  NotificationInfoPage({Key? key, required this.data}) : super(key: key);

  @override
  State<NotificationInfoPage> createState() => _NotificationInfoPageState();
}

class _NotificationInfoPageState extends State<NotificationInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
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
                            "FROM",
                            style: TextStyle(
                              color: Colors.blueGrey[200],
                              height: 1.5,
                            ),
                          ),
                          Text(
                            widget.data['company']['company_name'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            datetime(widget.data['created_at'].toString()),
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
                          color: Color(0xff13C6C2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          receiver(widget.data['user_type'].toString()),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  SafeArea(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.data['subject'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${' ' * 5}' + widget.data['message'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              height: 1.5
                            ),
                          ),
                        ),
                      ],
                    ),),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
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

  String datetime(String dt){
    final DateTime now = DateTime.parse(dt);
    final String day = DateFormat.yMMMMd().format(now);
    final String time = DateFormat.jm().format(now);
    final date = day + "\n" + time;
    return date;
  }


}
