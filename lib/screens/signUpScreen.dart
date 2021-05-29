import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uportal/main.dart';
import 'package:uportal/screens/chatbotScreen.dart';
import 'package:uportal/screens/loginScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController fName = TextEditingController();
  TextEditingController mName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FocusNode myFocusNode = new FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void registerUser(BuildContext context) async {
    final User firebaseUser = (await _auth
            .createUserWithEmailAndPassword(
                email: email.text, password: password.text)
            .catchError((msgError) {
      displayToastMessage("Error: " + msgError.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      Map studentDataMap = {
        "fName": fName.text.trim(),
        "mName": mName.text.trim(),
        "lName": lName.text.trim(),
        "email": email.text.trim(),
      };
      studentRef.child(firebaseUser.uid).set(studentDataMap);
      displayToastMessage("User has been create successfully.", context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyChatbotScreen()));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: 350,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                        child: Column(
                          children: [
                            Text(
                              'Please Read Carefully!',
                              style: TextStyle(
                                  color: Color(0xff577CF5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                'UPortal is your friendly chatbot that responds to student queries. You can ask the chatbot about enrollment, scholarship, events and many more.',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                'For starters, you can type "Hi" and see what the chatbot will reply.',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Confirm',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xff577CF5)),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.only(left: 30, right: 30))),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: -60,
                        child: CircleAvatar(
                          backgroundColor: Color(0xff577CF5),
                          backgroundImage:
                              AssetImage("assets/chatbot-circular.png"),
                          radius: 50,
                        )),
                  ],
                ));
          });
    } else {
      displayToastMessage(
          "Error: User has not been created. Please try again.", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color(0xff7C7C7C),
        gravity: ToastGravity.CENTER);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage("assets/signUpScreenImage.png"),
                  fit: BoxFit.contain,
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: fName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff577CF5)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff577CF5)),
                        ),
                        labelText: 'First Name',
                        labelStyle: TextStyle(
                            color: myFocusNode.hasFocus
                                ? Color(0xff577CF5)
                                : Color(0xff848484)),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xff577CF5),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: mName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff577CF5)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff577CF5)),
                        ),
                        labelText: 'Middle Name',
                        labelStyle: TextStyle(
                            color: myFocusNode.hasFocus
                                ? Color(0xff577CF5)
                                : Color(0xff848484)),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xff577CF5),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: lName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff577CF5)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff577CF5)),
                        ),
                        labelText: 'Last Name',
                        labelStyle: TextStyle(
                            color: myFocusNode.hasFocus
                                ? Color(0xff577CF5)
                                : Color(0xff848484)),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xff577CF5),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff577CF5)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff577CF5)),
                        ),
                        labelText: 'Email Address',
                        labelStyle: TextStyle(
                            color: myFocusNode.hasFocus
                                ? Color(0xff577CF5)
                                : Color(0xff848484)),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Color(0xff577CF5),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: password,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff577CF5)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff577CF5)),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            color: myFocusNode.hasFocus
                                ? Color(0xff577CF5)
                                : Color(0xff848484)),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(0xff577CF5),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff577CF5), // background
                      onPrimary: Colors.white, // foreground
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                    ),
                    onPressed: () {
                      if (fName.text.length < 2) {
                        displayToastMessage(
                            "First Name must be alteast 2 characters", context);
                      } else if (mName.text.length < 2) {
                        displayToastMessage(
                            "Middle Name must be alteast 2 characters",
                            context);
                      } else if (lName.text.length < 2) {
                        displayToastMessage(
                            "Last Name must be alteast 2 characters", context);
                      } else if (!email.text.contains("@")) {
                        displayToastMessage(
                            "Email address is not valid.", context);
                      } else if (!email.text.contains("@")) {
                        displayToastMessage(
                            "Email address is not valid.", context);
                      } else if (password.text.length < 7) {
                        displayToastMessage(
                            "Password must be atleast 7 characters.", context);
                      } else {
                        registerUser(context);
                      }
                    },
                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(fontSize: 15, color: Color(0xff848484)),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Login here.',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff577CF5),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
