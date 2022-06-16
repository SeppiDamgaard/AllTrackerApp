
import 'dart:io';

import 'package:alltracker_app/components/styled_text_button.dart';
import 'package:alltracker_app/components/styled_text_field.dart';
import 'package:alltracker_app/pages/main_page.dart';
import 'package:alltracker_app/pages/register_user.dart';
import 'package:alltracker_app/utils/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const serverIp = 'https://10.0.2.2:49153/api/';
const storage = FlutterSecureStorage();

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AllTracker',
      theme: ThemeData.dark().copyWith(
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          centerTitle: true
        ),
        primaryColor: const Color(0xFFC568CA)
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;
  NavigatorState navigator = NavigatorState();
  ScaffoldMessengerState scaffoldMessenger = ScaffoldMessengerState();
  @override
  Widget build(BuildContext context) {
    navigator = Navigator.of(context);
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return FutureBuilder(
      future: ApiRepository().verifyLogin(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if(!snapshot.hasData) {
          return const Image(image: AssetImage("assets/logo.png"));
        } else {
          if(snapshot.data == true){
            return MainPage();
          } else {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Container()),
                      const Image(image: AssetImage('assets/logo.png')),
                      StyledTextField(
                        title: "Brugernavn", 
                        controller: _usernameController,
                        submitHandler: () => FocusScope.of(context).nextFocus(),
                      ),
                      StyledTextField(
                        title: "Kodeord", 
                        controller: _passwordController, 
                        obscureText: true,
                        lastField: true,
                        submitHandler: () async => await login(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: StyledTextButton(
                              text: "Login", 
                              callback: () async => await login(),
                              textColor: Colors.white,
                              backgroundColor: Colors.purple
                            ),
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      const Text("Har du ikke en bruger?"),
                      Row(
                        children: [
                          Expanded(
                            child: StyledTextButton(
                              text: "Opret en gratis", 
                              callback: () => navigator.push(
                                MaterialPageRoute(builder: (BuildContext context) => const RegisterUser())
                              ), 
                              textColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              borderColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ]
                  ),
                ),
              ),
            );
          }
        }
      }
    );
  }
  Future<void> login() async {
    FocusScope.of(context).unfocus();
    final jwt = await ApiRepository().attemptLogIn(
      _usernameController.text, 
      _passwordController.text
    );

    if(jwt == "") {
      navigator.pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => MainPage())
        );
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(jwt))
      );
    }
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
