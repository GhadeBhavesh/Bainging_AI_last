import 'package:ai/bankpage.dart';
import 'package:ai/ai.dart';
import 'package:ai/main.dart';
import 'package:ai/widgets/transion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _signOut() async {
    await _auth.signOut();
  }

  Map<String, String> _questionsAndAnswers = {
    'How do I open an account?':
        'To open an account, visit our nearest branch with your valid identification and proof of address.',
    'How can I reset my password?':
        'You can reset your password by clicking on the "Forgot Password" link on the login page.',
    'What are the account fees?':
        'Account fees vary depending on the type of account you have. Please refer to our website or visit a branch for details.',
    'How do I report a lost card?':
        'To report a lost card, call our customer support hotline or visit a branch immediately.',
    'How can I contact customer support?':
        'You can contact customer support by calling our hotline at XXX-XXX-XXXX or by visiting our website for live chat.',
  };

  String? _selectedQuestion;
  bool _assistantVisible = false;
  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(206, 13, 13, 199),
        title: Text('Bank Support'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
      ),
      drawer: Drawer(
          backgroundColor: Color.fromARGB(206, 13, 13, 199),
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(206, 13, 13, 199),
              ),
              accountName: Text(currentUser?.displayName ?? ""),
              accountEmail: Text(currentUser?.email ?? ""),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(currentUser?.photoURL ??
                    "https://th.bing.com/th/id/OIP.L8bs33mJBAUBA01wBfJnjQHaHa?pid=ImgDet&rs=1"),
              ),
            ),
            ListTile(
              title: Text(
                'Home',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to Contact Page
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              title: Text('Transaction', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to Contact Page
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BankPage()));
              },
            ),
            ListTile(
              title: Text('History', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to Contact Page
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Transaction()));
              },
            ),
            ListTile(
              title: Text('Support', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to Contact Page
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  onPressed: () {
                    _signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  },
                  child: Text("Logout")),
            ),
          ])),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/back.jpg"), fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: _questionsAndAnswers.keys.map((question) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 29, 101, 209),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedQuestion =
                            _selectedQuestion == question ? null : question;
                      });
                    },
                    child: Text(question),
                  ),
                  if (_selectedQuestion == question)
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 252, 252, 252)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _questionsAndAnswers[question]!,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          onPressed: () async {
            KommunicateFlutterPlugin.openConversations();
            dynamic conversationObject = {
              'appId': "366ac44fa07a1a7fe1ebdbdbce64a6d53"
            };
            KommunicateFlutterPlugin.buildConversation(conversationObject)
                .then((result) {
              print("Conversation builder success : " + result.toString());
            }).catchError((error) {
              print(
                  "Conversation builder error occurred : " + error.toString());
            });
          },
          icon: Icon(Icons.help),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
