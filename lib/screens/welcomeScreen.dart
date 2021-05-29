import 'package:flutter/material.dart';
import 'package:uportal/screens/loginScreen.dart';
import 'package:uportal/screens/signUpScreen.dart';

void main() {
  runApp(WelcomeScreen());
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  navigateToLogin() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  navigateToRegistration() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image(
                image: AssetImage("assets/welcomeScreenImage.png"),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            RichText(
              text: TextSpan(
                text: "Welcome to ",
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff848484),
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'UPortal',
                      style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff577CF5))),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "Your Friendly Chatbot that Responds to Student Queries",
              style: TextStyle(
                color: Color(0xff848484),
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffFA80B1), // background
                    onPrimary: Colors.white, // foreground
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.only(left: 30, right: 30),
                  ),
                  onPressed: navigateToLogin,
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(width: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff577CF5), // background
                    onPrimary: Colors.white, // foreground
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.only(left: 30, right: 30),
                  ),
                  onPressed: navigateToRegistration,
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
