import 'package:ai/bankpage.dart';
import 'package:ai/ai.dart';
import 'package:ai/main.dart';
import 'package:ai/widgets/transion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _signOut() async {
    await _auth.signOut();
  }

  final Map<String, String> _questionsAndAnswers = {
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
  final bool _assistantVisible = false;
  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(206, 13, 13, 199),
        title:
            const Text('Bank Support', style: TextStyle(color: Colors.white)),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
      ),
      drawer: Drawer(
          backgroundColor: const Color.fromARGB(206, 13, 13, 199),
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(206, 13, 13, 199),
              ),
              accountName: Text(currentUser?.displayName ?? ""),
              accountEmail: Text(currentUser?.email ?? ""),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                    currentUser?.photoURL ?? "assets/profile_image.png"),
              ),
            ),
            ListTile(
              title: const Text(
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
              title: const Text('Transaction',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to Contact Page
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Bank()));
              },
            ),
            ListTile(
              title:
                  const Text('History', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to Contact Page
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Transactions()));
              },
            ),
            ListTile(
              title:
                  const Text('Support', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to Contact Page
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SupportPage()),
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
                  child: const Text("Logout")),
            ),
          ])),
      body: Container(
        decoration: const BoxDecoration(
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
                      backgroundColor: const Color.fromARGB(255, 29, 101, 209),
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
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 252, 252, 252)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _questionsAndAnswers[question]!,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: IconButton(
          onPressed: () async {
            KommunicateFlutterPlugin.openConversations();
            dynamic conversationObject = {
              'appId': "3692117feb9e94c821773fffea257ccbf"
            };
            KommunicateFlutterPlugin.buildConversation(conversationObject)
                .then((result) {
              print("Conversation builder success : $result");
            }).catchError((error) {
              print("Conversation builder error occurred : $error");
            });
          },
          icon: const Icon(
            Icons.help,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
