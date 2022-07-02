// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_final_fields

import 'package:devstack/pages/mainPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:devstack/pages/Backgrounds/backgroundSignIn.dart';
//import 'package:signup_login/pages/Backgrounds/backgroundSignIn.dart';
//import 'package:signup_login/pages/HomePage.dart';
import 'HomePage.dart';
//import 'HomePage.dart';
import '../pages/registration_screen.dart';
//import 'package:signup_login/pages/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  FirebaseAuth _auth = FirebaseAuth.instance;
  //FirebaseAuth firebaseAuth =  FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget textItem5() {
      return Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 70,
        child: TextFormField(
          autofocus: false,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            RegExp regex = new RegExp(r'^.{3,}$');
            if (value!.isEmpty) {
              return ("First Name cannot be Empty");
            }
            if (!regex.hasMatch(value)) {
              return ("Enter Valid name(Min. 3 Character)");
            }
            return null;
          },
          onSaved: (value) {
            emailController.text = value!;
          },
          textInputAction: TextInputAction.next,
          style: TextStyle(
            fontSize: 17,
            color: Color(0xff5d5fef),
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: Icon(Icons.mail_outline_rounded),
            contentPadding: EdgeInsets.fromLTRB(10, 15, 20, 15),
            labelText: "Email",
            labelStyle: TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                width: 1.5,
                color: Color(0xff5d5fef),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }

    Widget textItem6() {
      return Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 70,
        child: TextFormField(
          obscureText: true,
          autofocus: false,
          controller: passwordController,
          keyboardType: TextInputType.name,
          validator: (value) {
            RegExp regex = new RegExp(r'^.{6,}$');
            if (value!.isEmpty) {
              return ("Password is required for login");
            }
            if (!regex.hasMatch(value)) {
              return ("Enter Valid Password(Min. 6 Character)");
            }
          },
          onSaved: (value) {
            emailController.text = value!;
          },
          textInputAction: TextInputAction.next,
          style: TextStyle(
            fontSize: 17,
            color: Color(0xff5d5fef),
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: Icon(Icons.account_circle_outlined),
            contentPadding: EdgeInsets.fromLTRB(10, 15, 20, 15),
            labelText: "Password",
            labelStyle: TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                width: 1.5,
                color: Color(0xff5d5fef),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(
                width: 1,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }

    Widget loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(50),
      color: Color(0xff5d5fef),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width - 80,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: Text(
            "Sign In",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Background3(
          //height: MediaQuery.of(context).size.height,
          //width: MediaQuery.of(context).size.width,
          //color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SvgPicture.asset(
                "assets/signin.svg",
                height: size.height * 0.36,
              ),
              SizedBox(
                height: 20,
              ),
              textItem5(),
              SizedBox(
                height: 1,
              ),
              textItem6(),
              SizedBox(
                height: 10,
              ),
              loginButton,
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "If you don't have an Account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => RegistrationScreen()),
                          (route) => false);
                    },
                    child: Text(
                      "SignUp",
                      style: TextStyle(
                        color: Color(0xff5d5fef),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    //if (_formKey.currentState!.validate()) {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => MainPage()),
                    (route) => false)
              });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";

          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      Fluttertoast.showToast(msg: errorMessage!);
      print(error.code);
    }
  }

  void storeTokenAndData(UserCredential userCredential) async {
    print("aaa-Login screen-storing token and data");
    await storage.write(
        key: "token", value: userCredential.credential!.token.toString());
    await storage.write(
        key: "usercredential", value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }
}
//}
