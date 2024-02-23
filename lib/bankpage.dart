import 'dart:async';
import 'dart:ffi';
import 'package:ai/bankpage.dart';
import 'package:ai/support.dart';
import 'package:ai/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/transaction_data.dart';
import 'package:ai/support.dart';
import 'package:ai/widgets/transion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class BalancePage extends StatefulWidget {
//   @override
//   _BalancePageState createState() => _BalancePageState();
// }

// class _BalancePageState extends State<BalancePage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   int balance = 10000;
//   int transferAmount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _fetchBalance();
//   }

//   void _fetchBalance() async {
//     try {
//       DocumentSnapshot snapshot =
//           await _firestore.collection('balances').doc('user1').get();
//       if (snapshot.exists) {
//         setState(() {
//           // balance = snapshot.data() != null
//           //     ? (snapshot.data()['balance'] ?? 10000)
//           //     : 10000;
//         });
//       }
//     } catch (e) {
//       print("Error fetching balance: $e");
//     }
//   }

//   void _transferMoney(int amount) async {
//     if (balance >= amount) {
//       setState(() {
//         balance -= amount;
//       });
//       await _firestore
//           .collection('balances')
//           .doc('user1')
//           .update({'balance': balance});
//     } else {
//       // Show some error message or handle insufficient balance
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Balance Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Balance: $balance',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 setState(() {
//                   transferAmount = int.tryParse(value) ?? 0;
//                 });
//               },
//               decoration: InputDecoration(
//                 labelText: 'Enter amount to transfer',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 _transferMoney(transferAmount);
//               },
//               child: Text('Transfer Money'),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Users:',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             // List of users to whom you can transfer money
//             // Replace this with your actual user list from Firebase
//             ListTile(
//               leading: CircleAvatar(
//                 // Replace with user's logo or image from Firebase
//                 child: Icon(Icons.person),
//               ),
//               title: Text('User 1'),
//               onTap: () {
//                 _transferMoney(100); // Example: Transfer $100 to User 1
//               },
//             ),
//             // Add more ListTile widgets for additional users
//           ],
//         ),
//       ),
//     );
//   }
// }

class Transfer {
  final String recipient;
  final double amount;
  final DateTime date;
  final String profilePictureUrl;

  Transfer(this.recipient, this.amount, this.date, this.profilePictureUrl);
}

class BankPage extends StatefulWidget {
  @override
  _BankPageState createState() => _BankPageState();
}

class _BankPageState extends State<BankPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _userBalanceRef =
      FirebaseDatabase.instance.reference().child('user_balances');

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  void _signOut() async {
    await _auth.signOut();
  }

  UserAccount user1 = UserAccount('User 1', 1000.0);

  List<UserAccount> fakeAccounts = [
    UserAccount('User 2', 500.0),
    UserAccount('User 3', 750.0),
    UserAccount('User 4', 1200.0),
    UserAccount('User 5', 300.0),
  ];

  UserAccount? selectedAccount;
  List<Transfer> transferHistory = [];

  TextEditingController _amountController =
      TextEditingController(); // Controller for the amount input

  void _showAccountSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select an Account to Send Money'),
          content: SingleChildScrollView(
            child: ListBody(
              children: fakeAccounts.map((UserAccount account) {
                return ListTile(
                  title: Text(account.name),
                  onTap: () {
                    setState(() {
                      selectedAccount = account;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _amountController
        .dispose(); // Dispose of the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    void _updateUserBalance(double newBalance) {
      _userBalanceRef.child(currentUser!.uid).set(newBalance);
    }

    void _getUserBalance() {
      _userBalanceRef
          .child(currentUser!.uid)
          .once()
          .then((DataSnapshot snapshot) {
            if (snapshot.value != null) {
              setState(() {
                user1.balance = double.parse(snapshot.value.toString());
              });
            }
          } as FutureOr Function(DatabaseEvent value));
    }

    void _sendMoney(UserAccount fromUser, UserAccount toUser, double amount) {
      setState(() {
        if (fromUser.balance >= amount) {
          fromUser.balance -= amount;
          toUser.balance += amount;
          transferHistory.add(Transfer(
            toUser.name,
            amount,
            DateTime.now(),
            toUser.profilePictureUrl,
          ));
          _amountController.clear();

          // Update balance in Firebase after sending money
          _updateUserBalance(fromUser.balance);
        }
      });
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromARGB(206, 13, 13, 199),
            title: Text(
              'Transfer',
              style: TextStyle(color: Colors.white),
            ),
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
            )),
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
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${user1.name} Balance: \₹${user1.balance}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showAccountSelectionDialog(context);
                  },
                  child: Text('Select User to Send Money'),
                ),
                SizedBox(height: 20),
                if (selectedAccount != null)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          6,
                          20,
                          6,
                        ),
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration:
                              InputDecoration(labelText: 'Enter Amount'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          double amount =
                              double.tryParse(_amountController.text) ?? 0.0;
                          if (amount > 0) {
                            _sendMoney(user1, selectedAccount!, amount);
                          }
                        },
                        child: Text('Send Money to ${selectedAccount!.name}'),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            TransferHistoryPage(transferHistory),
                      ),
                    );
                  },
                  child: Text('View Transfer History'),
                ),
              ],
            ),
          ),
        ));
  }
}

class UserAccount {
  String name;
  double balance;
  String profilePictureUrl;

  UserAccount(this.name, this.balance, {this.profilePictureUrl = ''});
}

class TransferHistoryPage extends StatelessWidget {
  final List<Transfer> transferHistory;

  TransferHistoryPage(this.transferHistory);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transfer History',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: transferHistory.length,
        itemBuilder: (context, index) {
          Transfer transfer = transferHistory[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(transfer.profilePictureUrl),
            ),
            title: Text('To: ${transfer.recipient}'),
            subtitle: Text('Amount: \₹${transfer.amount}'),
            trailing: Text('Date: ${transfer.date.toString()}'),
          );
        },
      ),
    );
  }
}
