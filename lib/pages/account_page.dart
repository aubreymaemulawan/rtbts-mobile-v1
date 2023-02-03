import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/account_password_page.dart';
import 'package:flutter_login_ui/pages/account_profile_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_ui/Services/auth_services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AccountPage extends StatefulWidget {

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  var response;
  bool _isOpen = false;
  PanelController _panelController = PanelController();

  Future fetchAccountInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final value1 = prefs.getString('email').toString();
    final value2 = prefs.getString('password').toString();
    final value3 = prefs.getInt('personnel_id');
    http.Response response = await UserServices.user(value1, value2, value3!);
    print('>>> For Account Page');
    Map responseMap = jsonDecode(response.body);
    return responseMap['user'];
  }

  @override
  void initState() {
    _AccountPageState();
    response = fetchAccountInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Settings",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        leading: Container(
          child: Row(
            children: [
              IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Icon(Icons.arrow_back),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.white)
            ],
          ),
        ),
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/user.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
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
            minHeight: MediaQuery.of(context).size.height * 0.35,
            maxHeight: MediaQuery.of(context).size.height * 0.80,
            body: GestureDetector(
              onTap: () => _panelController.close(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
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

  // TODO: Future builder for fetched data
  FutureBuilder _panelBody(ScrollController controller) {
    double hPadding = 40;
    return FutureBuilder(
      future: response,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          final String dt = snapshot.data['personnel']['updated_at'];
          final DateTime now = DateTime.parse(dt).toLocal();
          final String day = DateFormat.yMMMMd().format(now);
          final String time = DateFormat.jm().format(now);
          final date = day + "  " + time;
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          snapshot.data['name'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          userType(snapshot.data['user_type']),
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _infoCell(title: 'Company', value: snapshot.data['personnel']['company']['company_name'].toString()),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey,
                        ),
                        _infoCell(title: 'Personnel No.', value: snapshot.data['personnel']['personnel_no'].toString()),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey,
                        ),
                        _infoCell(title: 'No. of Trips', value: snapshot.data['personnel']['age'].toString()), /// Change Value
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Visibility(
                          visible: !_isOpen,
                          child: Expanded(
                            child: OutlineButton(
                              onPressed: () => _panelController.open(),
                              borderSide: BorderSide(color: Color(0xff41729F)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                'VIEW PROFILE',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !_isOpen,
                          child: SizedBox(
                            width: 16,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: _isOpen
                                  ? (MediaQuery.of(context).size.width - (2 * hPadding)) / 1.6
                                  : double.infinity,
                              child: RaisedButton(
                                onPressed: () => {
                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdatePasswordPage())),
                                },
                                color: Color(0xff41729F),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  'UPDATE PASSWORD',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
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
              Expanded(
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child:
                  Column(
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
                                            text: "Last Updated: ",
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
                                onTap: () => {
                                  Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => UpdateProfilePage(data: snapshot.data)))
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.info, size: 20),
                                          SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Age",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                snapshot.data['personnel']['age'].toString(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.call,size: 20),
                                          SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Contact Number",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                snapshot.data['personnel']['contact_no'].toString(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.location_on,size: 20),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Address",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  snapshot.data['personnel']['address'].toString(),
                                                  maxLines: 2,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
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
                  ),
                ),
              ),
            ],
          );
        }
        else{
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }

  // TODO: Convert User Type
  String userType(int type){
    String user = "";
    if(type == 2){user = "Conductor";}
    return user;
  }

  /// Info Cell
  Column _infoCell({required String title, required String value}) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}