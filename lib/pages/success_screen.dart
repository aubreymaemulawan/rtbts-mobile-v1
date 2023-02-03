
import 'package:flutter/material.dart';
import '../common/theme_helper.dart';
import '../home.dart';
import 'account_page.dart';

class SuccessPage extends StatefulWidget {
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  const SuccessPage({Key? key, required this.text1, required this.text2, required this.text3, required this.text4, }) : super(key: key);

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  late AssetImage image;

  @override
  void initState() {
    super.initState();
    image = AssetImage('assets/images/success.gif');
  }

  @override
  void dispose() {
    image.evict();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var text1 = widget.text1;
    var text2 = widget.text2;
    var text3 = widget.text3;
    var text4 = widget.text4;
    return Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).accentColor,]
                  )
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Container(
                  height: MediaQuery.of(context).size.height - 80,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/images/success.gif'),
                              height: 150.0,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: text1,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 25),
                                        ),
                                        TextSpan(
                                          text: text2,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 25),
                                        ),
                                      ]),
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 200),
                        child: Text(
                          text3,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black45),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                        child: Container(
                            decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(text4.toUpperCase(), style: TextStyle(fontSize: 15, color: Colors.white),
                                      ),
                                      SizedBox(width: 10,),
                                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15,)
                                    ],
                                  ),
                                ),
                                onPressed: () => {
                                  widget.text4 == 'PROFILE' ?
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountPage())) :
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(tab: 0))),
                                }
                              //     (){
                              //   //After successful login we will redirect to profile page. Let's create profile page now
                              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home())),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )

    );
  }
}



