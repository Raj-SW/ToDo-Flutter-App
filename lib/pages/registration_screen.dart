// ignore_for_file: unnecessary_new, prefer_const_constructors, use_build_context_synchronously

import 'package:devstack/pages/Backgrounds/backgroundSignUp.dart';
import 'package:devstack/pages/mainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:devstack/Service/Auth_Service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../pages/face_page.dart';
import '../pages/PhoneAuth.dart';
import '../pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import '../model/user_model.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();
  //gender
  int? gender;
  // editing Controller
  final nameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  AuthClass authClass = AuthClass();
  final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    Widget buttonItem(
        String imagepath, String buttonName, double size, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Color(0xff5d5fef),
            ),
            shape: BoxShape.circle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagepath,
                height: size,
                width: size,
              ),
              Text(
                buttonName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget textItem1() {
      return Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 50,
        child: TextFormField(
          autofocus: false,
          controller: nameEditingController,
          keyboardType: TextInputType.name,
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
            nameEditingController.text = value!;
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
            labelText: "Name",
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

    Widget textItem2() {
      return Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 50,
        child: TextFormField(
          autofocus: false,
          controller: emailEditingController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Please Enter Your Email");
            }
            // reg expression for email validation
            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                .hasMatch(value)) {
              return ("Please Enter a valid email");
            }
            return null;
          },
          onSaved: (value) {
            nameEditingController.text = value!;
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

    Widget textItem3() {
      return Container(
          width: MediaQuery.of(context).size.width - 70,
          height: 50,
          child: TextFormField(
            obscureText: true,
            autofocus: false,
            controller: passwordEditingController,
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
              nameEditingController.text = value!;
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
              prefixIcon: Icon(Icons.lock_outline_rounded),
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
          ));
    }

    Widget textItem4() {
      return Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 55,
        child: TextFormField(
          autofocus: false,
          controller: confirmPasswordEditingController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            fontSize: 17,
            color: Color(0xff5d5fef),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline_rounded),
            contentPadding: EdgeInsets.fromLTRB(10, 15, 20, 15),
            labelText: "Confirm Password",
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

    Widget textItem5() {
      return Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 80,
        child: TextFormField(
          autofocus: false,
          controller: nameEditingController,
          keyboardType: TextInputType.name,
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
            nameEditingController.text = value!;
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
            labelText: "Gender",
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

    //signup button
    final signUpButton = Material(
      borderRadius: BorderRadius.circular(50),
      color: Color(0xff5d5fef),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width - 80,
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: Text(
            "Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Background2(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 5),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SvgPicture.asset(
                    "assets/signup.svg",
                    height: size.height * 0.25,
                  ),
                  SizedBox(height: 10.2),
                  textItem1(),
                  SizedBox(height: 20),
                  Container(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                            value: 1,
                            groupValue: gender,
                            onChanged: (value) => setState(() {
                                  gender = 1;
                                  print("Gender is Male");
                                  print(gender);
                                })),
                        Text(
                          "Male",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Radio(
                            value: 0,
                            groupValue: gender,
                            onChanged: (value) => setState(() {
                                  gender = 0;
                                  print("Gender is female");
                                  print(gender);
                                })),
                        Text(
                          "Female",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  //emailField,
                  textItem2(),
                  SizedBox(height: 20),
                  //passwordField,
                  textItem3(),
                  SizedBox(height: 20),
                  signUpButton,
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If you already have an Account? ",
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
                                  builder: (builder) => LoginScreen()),
                              (route) => false);
                        },
                        child: Text(
                          "Sign in",
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
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Color(0xffd6d6e2),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    Text(
                      "OR",
                      style: TextStyle(fontSize: 16, color: Color(0xff5d5fef)),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Color(0xffd6d6e2),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 10,
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          child: buttonItem(
                            "assets/google1.svg",
                            "",
                            30,
                            () async {
                              await authClass.googleSignIn(context);
                            },
                          ),
                        ),
                        Expanded(
                          child:
                              buttonItem("assets/fingerprint.svg", "", 30, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => FacePage()));
                          }),
                        ),
                        Expanded(
                          child: buttonItem("assets/otp.svg", "", 30, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => PhoneAuthPage()));
                          }),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        authClass.storeTokenAndData2(userCredential);
        initialiseDB();
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(builder: (context) => MainPage()),
            (route) => false);
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
  }

  void initialiseDB() {
    print("Initialising Db");
    FirebaseFirestore.instance
        .collection("collect2")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userModel")
        .doc("userDetails")
        .set({
      "Experience": 0,
      "Gender": gender,
      "Level": 0,
      "userName": nameEditingController.text,
    });
  }
}
