import 'package:alltracker_app/pages/main_page.dart';
import 'package:flutter/material.dart';

import '../components/styled_text_button.dart';
import '../components/styled_text_field.dart';
import '../utils/api_repository.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController repeatPasswordController = TextEditingController();
    final NavigatorState navigator = Navigator.of(context);
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
              StyledTextField(title: "Brugernavn", controller: usernameController),
              StyledTextField(title: "Kodeord", controller: passwordController, obscureText: true,),
              StyledTextField(title: "Gentag kodeord", controller: repeatPasswordController, obscureText: true,),
              Row(
                children: [
                  Expanded(
                    child: StyledTextButton(
                      text: "Opret og login", 
                      callback: () async {
                        FocusScope.of(context).unfocus();
                        if (passwordController.text == repeatPasswordController.text){
                          var response = await ApiRepository().registerUser(
                            usernameController.text, 
                            passwordController.text,
                          );
                          if (response == "") 
                          {
                            navigator.pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) => MainPage())
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Kodeordene er ikke ens"))
                          );
                        }
                      },
                      textColor: Colors.white,
                      backgroundColor: Colors.purple
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              const Text("Har du allerede en bruger?"),
              Row(
                children: [
                  Expanded(
                    child: StyledTextButton(
                      text: "Tilbage til login", 
                      callback: () => Navigator.of(context).pop(), 
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