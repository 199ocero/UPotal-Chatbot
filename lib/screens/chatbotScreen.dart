import 'package:bubble/bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uportal/screens/welcomeScreen.dart';

void main() {
  runApp(MyChatbotScreen());
}

class MyChatbotScreen extends StatefulWidget {
  MyChatbotScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyChatbotScreenState createState() => _MyChatbotScreenState();
}

class _MyChatbotScreenState extends State<MyChatbotScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLogin = false;
  User user;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isLogin = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
    this.fetchUser();
  }

  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/uportal-credential.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });

    print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());
  }

  final messageInsert = TextEditingController();
  List<Map> messsages = [];

  signOut() async {
    _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
  }

  String email = "", fName = "", mName = "", lName = "";
  fetchUser() {
    final User user = _auth.currentUser;
    final uid = user.uid;
    var dbRef = FirebaseDatabase.instance.reference().child("students");
    dbRef.orderByKey().equalTo(uid).once().then((DataSnapshot snapshot) {
      if (snapshot.value.isNotEmpty) {
        var ref = FirebaseDatabase.instance.reference().child("students");
        ref.child(uid).once().then((DataSnapshot snapshot) {
          email = snapshot.value['email'];
          fName = snapshot.value['fName'];
          mName = snapshot.value['mName'];
          lName = snapshot.value['lName'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff577CF5),
        elevation: 0,
        title: Text(
          "UPortal",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
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
                              height: 300,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 70, 10, 10),
                                child: Column(
                                  children: [
                                    Text(
                                      'Profile Settings',
                                      style: TextStyle(
                                          color: Color(0xff577CF5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text(
                                        'Email: $email\nFirst Name: $fName\nMiddle Name: $mName\nLast Name: $lName',
                                        style: TextStyle(fontSize: 15),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Confirm',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xff577CF5)),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.only(
                                                          left: 30,
                                                          right: 30))),
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            signOut();
                                          },
                                          child: Text(
                                            'Logout',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Color(0xff577CF5)),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.only(
                                                          left: 30,
                                                          right: 30))),
                                        ),
                                      ],
                                    )
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
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                "Today, ${DateFormat("Hm").format(DateTime.now())}",
                style: TextStyle(fontSize: 15, color: Color(0xff848484)),
              ),
            ),
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => chat(
                        messsages[index]["message"].toString(),
                        messsages[index]["data"]))),
            SizedBox(
              height: 20,
            ),
            Divider(
              height: 5.0,
              color: Color(0xff848484),
            ),
            Container(
              child: ListTile(
                title: Container(
                  child: TextFormField(
                    controller: messageInsert,
                    minLines: 1,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Color(0xff848484)),
                      fillColor: Color(0xffF3F3F5),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                trailing: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 30.0,
                      color: Color(0xffFA80B1),
                    ),
                    onPressed: () {
                      if (messageInsert.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Empty message. Please try again.",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Color(0xff7C7C7C),
                            gravity: ToastGravity.CENTER);
                      } else {
                        setState(() {
                          messsages.insert(
                              0, {"data": 1, "message": messageInsert.text});
                        });
                        response(messageInsert.text);
                        messageInsert.clear();
                      }
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    }),
              ),
            ),
            SizedBox(
              height: 5.0,
            )
          ],
        ),
      ),
    );
  }

  Widget chat(String message, int data) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 40,
                  width: 40,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/bot.jpg"),
                  ),
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Bubble(
                radius: Radius.circular(15.0),
                color: data == 0 ? Color(0xffFA80B1) : Color(0xff577CF5),
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                          child: Container(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          message,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ))
                    ],
                  ),
                )),
          ),
          data == 1
              ? Container(
                  height: 40,
                  width: 40,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/default.jpg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
