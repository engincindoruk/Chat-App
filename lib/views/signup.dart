import 'package:chat_app_tutorial/helper/helperfunctions.dart';
import 'package:chat_app_tutorial/services/auth.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/chatRoomsScreen.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toogle;
  SignUp(this.toogle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  signMeUp(BuildContext context) {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpwithEmailandPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        //print("${value.uid}");

        Map<String, String> userInfoMap = {
          "name": usernameTextEditingController.text,
          "email": emailTextEditingController.text
        };

        HelperFunctions.saveUserEmailSharedPreference(
            emailTextEditingController.text);
        HelperFunctions.saveUserNameSharedPreference(
            usernameTextEditingController.text);

        databaseMethods.uploadUserInfo(
            userInfoMap); //yukarıda map ile aldık tekrar bilgileri üyeyi authenticationda kaydettik zaten şimdide database kayıt ediyoruz burda
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoom(),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                  child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Colors.white), //burda progress rengini değiştirmiş olduk
              )),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 80,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Form(
                      key: formkey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                              validator: (value) {
                                return value.isEmpty || value.length < 6
                                    ? "Please Provide a valid Username"
                                    : null;
                              },
                              controller: usernameTextEditingController,
                              style: simpleTextStyle(),
                              cursorColor: Colors.white,
                              decoration: textFieldInputDecoration("username")),
                          TextFormField(
                              validator: (value) {
                                return value.isEmpty ||
                                        value.length < 6 ||
                                        !value.contains("@") ||
                                        !value.endsWith(".com")
                                    ? "Please Provide a valid Email"
                                    : null;
                              },
                              controller: emailTextEditingController,
                              style: simpleTextStyle(),
                              cursorColor: Colors.white,
                              decoration: textFieldInputDecoration("email")),
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              return value.length > 5
                                  ? null
                                  : "Please Provide a valid password";
                            },
                            controller: passwordTextEditingController,
                            style: simpleTextStyle(),
                            cursorColor: Colors.white,
                            decoration: textFieldInputDecoration("password"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text(
                        "ForgotPassword?",
                        style: simpleTextStyle(),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        signMeUp(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(colors: [
                              //renk karışımları yapmamızı sağlıyor
                              const Color(0xff005EF4),
                              const Color(0xff2A75BC),
                            ])),
                        child: Text(
                          "Sign Up",
                          style: mediumTextStyle(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      child: Text(
                        "Sign Up with Google",
                        style: TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have account? ",
                          style: mediumTextStyle(),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toogle();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "SignIn now",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
