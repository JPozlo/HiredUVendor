import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/pages/pages.dart';
import 'package:hired_u_vendor/providers/providers.dart';
import 'package:hired_u_vendor/utils/utils.dart';
import 'package:hired_u_vendor/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = new GlobalKey<FormState>();
  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final emailInput = TextFormField(
        validator: validateEmail,
        onSaved: (value) => _email = value!,
        decoration: inputFieldDecoration("Enter your email address"));
    final passwordInput = TextFormField(
        obscureText: true,
        validator: (value) => value!.isEmpty ? "Please enter password" : null,
        onSaved: (value) => _password = value!,
        decoration: inputFieldDecoration("Enter your password"));

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    doLogin () {
      final form = _formKey.currentState;
      if (form!.validate()) {
        form.save();

        final Future<Result> loginResponse = auth.login(_email, _password);

        loginResponse.then((response) {
          if (response.status) {
            userProvider.user = response.user!;
            nextScreen(
                context,
                MainHome(
                  user: response.user,
                ));
          } else {
            Flushbar(
              title: "Failed Login",
              message: response.message.toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Invalid form",
          message: "Please Complete the form properly",
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };

    return Scaffold(
      backgroundColor: AppTheme.mainOrangeColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 15.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Log in to your account",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Flexible(
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight:
                                MediaQuery.of(context).size.height - 180.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                label("Email"),
                                SizedBox(
                                  height: 7.0,
                                ),
                                emailInput,
                                SizedBox(
                                  height: 25.0,
                                ),
                                label("Password"),
                                SizedBox(
                                  height: 7.0,
                                ),
                                passwordInput,
                                SizedBox(
                                  height: 20.0,
                                ),
                                auth.loggedInStatus == Status.Authenticating
                                    ? loading
                                    : AppButton(
                                        type: ButtonType.PRIMARY,
                                        text: "Log In",
                                        onPressed: doLogin
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => MainHome() ));
                                        ),
                                SizedBox(
                                  height: 40.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
