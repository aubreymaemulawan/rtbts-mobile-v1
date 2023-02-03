import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/account_page.dart';
import 'package:flutter_login_ui/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Services/globals.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final int num;
  const MenuItem({Key? key, required this.title, required this.icon, required this.num}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uri _url = Uri.parse('https://rtbts-ph.000webhostapp.com');

    // TODO: Open Browser
    Future<void> _launchUrl() async {
      if (!await launchUrl(_url)) {
        throw errorSnackBar(context, 'Could not launch $_url');
      }
    }

    // TODO: Logout User
    Future logOut(BuildContext context)async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      preferences.remove('email');
      successSnackBar(context, 'Logout Successful.');
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    }

    // TODO: Logout Dialog Confirmation
    Future<void> logOut_confirm(BuildContext context) async {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: const Text('Please Confirm'),
              content: const Text('Are you sure to logout?'),
              actions: [
                TextButton(
                    onPressed: () {
                        logOut(context);
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
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

    return Container(
      child: Material(
        child: InkWell(
          splashColor: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xff375BE9),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(
                        icon,
                        color: Colors.white,
                        size: 20)
                ),
                SizedBox(width: 15),
                Expanded(child: Text(title, style: TextStyle(fontSize: 17, color: Colors.black54)),),
                Icon(Icons.arrow_forward_ios, color: Color(0xff5885AF), size: 15, ),
              ],
            ),
          ),
          onTap: () => {
            if(num==1){
              _launchUrl()
            }else if(num==2){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage())),
            }else if(num==3){
              logOut_confirm(context)
            }
          },
        ),
        color: Colors.transparent,
      ),
    );

  }



}
