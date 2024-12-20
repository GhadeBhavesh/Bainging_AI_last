import 'package:ai_assistent/bankpage.dart';
import 'package:ai_assistent/support.dart';
import 'package:ai_assistent/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/transaction_data.dart';
import '../main.dart';
import '../screens/card_screen.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _signOut() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(206, 13, 13, 199),
          title: Text(
            'Transition',
            style: TextStyle(color: Colors.white),
          ),
          // Add hamburger menu icon to the AppBar
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
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
            backgroundColor: Color.fromARGB(206, 13, 13, 199),
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
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
                title:
                    Text('Transaction', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navigate to Contact Page
                  Navigator.pop(context);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Bank()));
                },
              ),
              ListTile(
                title: Text('History', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navigate to Contact Page
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Transactions()));
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPage()));
                    },
                    child: Text("Logout")),
              ),
            ])),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/back.jpg"), fit: BoxFit.cover),
            ),
            // padding: const EdgeInsets.all(20.0),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.separated(
                          itemCount: myTransactions.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                          itemBuilder: (context, index) {
                            return TransactionCard(
                                transaction: myTransactions[index]);
                          })
                    ]))));
  }
}
