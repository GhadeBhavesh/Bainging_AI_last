import 'package:ai/bankpage.dart';
import 'package:ai/screens/base_scren.dart';
import 'package:ai/screens/card_screen.dart';
import 'package:ai/support.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ai/widgets/transaction_card.dart';
import 'package:ai/widgets/transion.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';
import 'dart:convert';
import 'constants/app_textstyle.dart';
import 'data/card_data.dart';
import 'data/transaction_data.dart';
import 'secret.dart';

void main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Authentication',
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SignInPage();
          } else {
            return HomePage();
          }
        }
        return CircularProgressIndicator(); // Loading state
      },
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  Future<void> _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print("Sign-in error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: Center(
            child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/logo.jpg"),
                          fit: BoxFit.fitHeight),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 290,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.email_outlined),
                              labelText: 'Email'),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outlined),
                                labelText: 'Password',
                                filled: true,
                                border: const OutlineInputBorder(),
                                fillColor: Colors.white,
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    }))),
                        SizedBox(height: 60),
                        ElevatedButton(
                          onPressed: _signInWithEmailAndPassword,
                          child: Text('Sign In'),
                        ),
                        SizedBox(height: 100),
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage())),
                          child: Text('Create an Account'),
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _passwordVisible = false;
  Future<void> _registerWithUsernameAndPassword() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = _usernameController.text;

      await prefs.setString('username', username);

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print("Registration error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Register")),
        body: Center(
            child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/logo.jpg"),
                          fit: BoxFit.fitHeight),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250,
                        ),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(),
                              prefixIcon:
                                  const Icon(Icons.person_outline_outlined),
                              labelText: 'Username'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.email_outlined),
                              labelText: 'Email'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon:
                                  const Icon(Icons.phone_android_outlined),
                              border: const OutlineInputBorder(),
                              labelText: 'Phone no'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outlined),
                                focusColor: Colors.white,
                                labelText: 'Password',
                                filled: true,
                                border: const OutlineInputBorder(),
                                fillColor: Colors.white,
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    }))),
                        SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: _registerWithUsernameAndPassword,
                          child: Text('Register'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInPage()));
                            },
                            child: const Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: "Already have a account ? ",
                                  style: TextStyle(color: Colors.white)),
                              TextSpan(text: " login", style: TextStyle()),
                            ])))
                      ],
                    ),
                  ),
                ))));
  }
}

class HomePage extends StatelessWidget {
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
          title: Text('Home'),
          // Add hamburger menu icon to the AppBar
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPage()));
                    },
                    child: Text("Logout")),
              ),
            ])),
        body: Container(
          child: BaseScreen(),
        ));
  }
}

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeatureBox({
    super.key,
    required this.color,
    required this.headerText,
    required this.descriptionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0).copyWith(
          left: 15,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headerText,
                style: const TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                descriptionText,
                style: const TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Pallete {
  static const Color mainFontColor = Color.fromRGBO(19, 61, 95, 1);
  static const Color firstSuggestionBoxColor = Color.fromRGBO(165, 231, 244, 1);
  static const Color secondSuggestionBoxColor =
      Color.fromRGBO(157, 202, 235, 1);
  static const Color thirdSuggestionBoxColor = Color.fromRGBO(162, 238, 239, 1);
  static const Color assistantCircleColor = Color.fromRGBO(209, 243, 249, 1);
  static const Color borderColor = Color.fromRGBO(200, 200, 200, 1);
  static const Color blackColor = Colors.black;
  static const Color whiteColor = Colors.white;
}

class MyCard extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CardModel card;
  MyCard({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    return Container(
      padding: EdgeInsets.all(20),
      height: 200,
      width: 350,
      decoration: BoxDecoration(
        color: card.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CARD NAME",
                    style: ApptextStyle.MY_CARD_TITLE,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FutureBuilder<String?>(
                      future: SharedPreferences.getInstance()
                          .then((prefs) => prefs.getString('username')),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return Text(
                            ' ${snapshot.data}',
                            style: ApptextStyle.MY_CARD_SUBTITLE,
                          );
                        } else {
                          return Text('No username registered.');
                        }
                      },
                    ),
                  )
                ],
              ),
              Text(
                card.cardNumber,
                style: ApptextStyle.MY_CARD_SUBTITLE,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "EXP DATE",
                        style: ApptextStyle.MY_CARD_TITLE,
                      ),
                      Text(
                        card.expDate,
                        style: ApptextStyle.MY_CARD_SUBTITLE,
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CVV NUMBER",
                        style: ApptextStyle.MY_CARD_TITLE,
                      ),
                      Text(
                        card.cvv,
                        style: ApptextStyle.MY_CARD_SUBTITLE,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                child: Image.asset("assets/icons/mcard.png"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
