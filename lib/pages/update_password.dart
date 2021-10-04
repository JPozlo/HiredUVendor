import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/providers/providers.dart';
import 'package:hired_u_vendor/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({ Key? key }) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  late String _password, _newpassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        clipBehavior: Clip.antiAlias,
        overflow: Overflow.visible,
        children: [
          topBar(),
          detailsFormUpdate(context),
          // imageArea(this.widget.user)
        ],
      ),
    ));
  }

    Widget detailsFormUpdate(BuildContext context) {
        final _formKey = new GlobalKey<FormState>();
    UserProvider userProvider = Provider.of<UserProvider>(context);

    final passwordInput = TextFormField(
        obscureText: true,
        validator: (value) => value!.isEmpty ? "Please enter current password" : null,
        onSaved: (value) => _password = value!,
        decoration: inputFieldDecoration("Enter your current password"));
          final newPasswordInput = TextFormField(
        obscureText: true,
        validator: (value) => value!.isEmpty ? "Please enter new password" : null,
        onSaved: (value) => _newpassword = value!,
        decoration: inputFieldDecoration("Enter your new password"));

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Processing ... Please wait")
      ],
    );

    doUpdate () {
      final form = _formKey.currentState;
      if (form!.validate()) {
        form.save();

        UpdatePasswordDTO updateProfileDTO =
            UpdatePasswordDTO(password: _password, newPassword: _newpassword);
        final Future<Result> loginResponse =
            userProvider.updatePassword(updateProfileDTO);

        loginResponse.then((response) {
          if (response.status) {
            if (response.user != null) {
              userProvider.user = response.user!;
            }
            Fluttertoast.showToast(
                msg: "Successfully updated password information",
                toastLength: Toast.LENGTH_LONG);
            Navigator.pop(context);
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
    return Positioned(
        top: 60,
        left: 13,
        right: 13,
        // width: response.screenWidth,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              label("Current Password"),
              SizedBox(
                height: 7.0,
              ),
              passwordInput,
              label("New Password"),
              SizedBox(
                height: 7.0,
              ),
              newPasswordInput,
              SizedBox(
                height: 25.0,
              ),
              // label("Password"),
              // SizedBox(
              //   height: 7.0,
              // ),
              // passwordInput,
              SizedBox(
                height: 20.0,
              ),
              userProvider.processingStatus == ProcessingState.Processing
                  ? loading
                  : AppButton(
                      type: ButtonType.PRIMARY,
                      text: "Update",
                      onPressed: doUpdate
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => MainHome() ));
                      ),
            ],
          ),
        ));
  }
    Widget topBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Text("Profile"),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.arrow_back,
                  size: 24,
                ),
              ),
            ),
            Spacer(),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Update Profile",
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }

}