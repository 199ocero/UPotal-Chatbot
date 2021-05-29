import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uportal/screens/chatbotScreen.dart';
import 'package:uportal/screens/signUpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String _email, _password;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MyChatbotScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  loginValidation() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
              email: _email, password: _password))
          .user;
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
    } catch (e) {
      displayToastMessage(e.message, context);
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errormessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Confirm'),
              ),
            ],
          );
        });
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color(0xff7C7C7C),
        gravity: ToastGravity.CENTER);
  }

  FocusNode myFocusNode = new FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage("assets/loginScreenImage.png"),
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffFA80B1)),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffFA80B1)),
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                color: myFocusNode.hasFocus
                                    ? Color(0xffFA80B1)
                                    : Color(0xff848484)),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xffFA80B1),
                            ),
                          ),
                          onSaved: (input) => _email = input,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: TextFormField(
                          controller: password,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffFA80B1)),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffFA80B1)),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                color: myFocusNode.hasFocus
                                    ? Color(0xffFA80B1)
                                    : Color(0xff848484)),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color(0xffFA80B1),
                            ),
                          ),
                          obscureText: true,
                          onSaved: (input) => _password = input,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffFA80B1), // background
                          onPrimary: Colors.white, // foreground
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                        ),
                        onPressed: () {
                          if (!email.text.contains("@") || email.text.isEmpty) {
                            displayToastMessage(
                                "Email address is not valid or can't be empty.",
                                context);
                          } else if (password.text.length < 7) {
                            displayToastMessage(
                                "Password must be atleast 7 characters.",
                                context);
                          } else {
                            loginValidation();
                          }
                        },
                        child: Text(
                          "LOGIN",
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
                          text: 'No account yet? ',
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff848484)),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Register here.',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()));
                                  },
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffFA80B1),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
