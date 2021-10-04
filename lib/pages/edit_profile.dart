import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/pages/pages.dart';
import 'package:hired_u_vendor/providers/providers.dart';
import 'package:hired_u_vendor/services/services.dart';
import 'package:hired_u_vendor/utils/utils.dart';
import 'package:hired_u_vendor/widgets/widgets.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  late String _email, _password, _name, _phone;

  @override
  void initState() {
    super.initState();
    _emailController.text = this.widget.user.email!;
    _nameController.text = this.widget.user.name!;
    _phoneController.text = this.widget.user.phone ?? "";
  }

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

  Widget imageArea(User user) {
    return Positioned(
      top: 40,
      left: 50, right: 50,
      // width: response.screenWidth * 0.7,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(13.5))),
        width: response.setWidth(response.screenWidth! * 0.7),
        height: response.setHeight(210),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: user.profile == null
                    ? AssetImage("assets/avatar.png")
                    : NetworkImage(ApiService.imageBaseURL + user.profile!)
                        as ImageProvider,
                radius: 50.0,
              ),
              SizedBox(
                height: 13.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // nextScreen(context, EditProfilePage(user: user,));
                    },
                    child: Container(
                      child: SvgPicture.asset(
                        'assets/edit.svg',
                        width: 30,
                        height: 30,
                        color: AppTheme.mainBlueColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget detailsFormUpdate(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    final emailInput = TextFormField(
        controller: _emailController,
        validator: validateEmail,
        onSaved: (value) => _email = value!,
        decoration: inputFieldDecoration("Enter your email address"));
    final phoneInput = TextFormField(
        controller: _phoneController,
        validator: (value) {
          String? validator;
          if (value!.isEmpty) {
            validator = "Please fill in your phone number";
          }
          return validator;
        },
        onSaved: (value) => _phone = value!,
        decoration: inputFieldDecoration("Enter your phone number"));
    final nameInput = TextFormField(
        controller: _nameController,
        validator: (value) {
          String? validator;
          if (value!.isEmpty) {
            validator = "Please fill in your name";
          }
          return validator;
        },
        onSaved: (value) => _name = value!,
        decoration: inputFieldDecoration("Enter your name"));
    final passwordInput = TextFormField(
        obscureText: true,
        validator: (value) => value!.isEmpty ? "Please enter password" : null,
        onSaved: (value) => _password = value!,
        decoration: inputFieldDecoration("Enter your password"));

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Processing ... Please wait")
      ],
    );

    doUpdate() {
      final form = _formKey.currentState;
      if (form!.validate()) {
        form.save();

        print("Email value: $_email");

        UpdateProfileDTO updateProfileDTO =
            UpdateProfileDTO(name: _name, phone: _phone, email: _email);
        final Future<Result> loginResponse =
            userProvider.updateProfile(updateProfileDTO);

        loginResponse.then((response) {
          if (response.status) {
            if (response.user != null) {
              userProvider.user = response.user!;
            }
            Fluttertoast.showToast(
                msg: "Successfully updated information",
                toastLength: Toast.LENGTH_LONG);
            // Navigator.pop(context);
            nextScreen(context, MainHome());
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
    }

    ;
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
              label("Name"),
              SizedBox(
                height: 7.0,
              ),
              nameInput,
              label("Phone"),
              SizedBox(
                height: 7.0,
              ),
              phoneInput,
              label("Email"),
              SizedBox(
                height: 7.0,
              ),
              emailInput,
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
                      onPressed: () {
                        doUpdate();
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => MainHome() ));
                      ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          children: [TextSpan(text: "OR")]))
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              AppButton(
                  type: ButtonType.PRIMARY,
                  text: "Change Password",
                  onPressed: () {
                    nextScreen(context, UpdatePassword());
                  }),
            ],
          ),
        ));
  }
}
