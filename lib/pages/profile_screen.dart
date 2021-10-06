import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/pages/pages.dart';
import 'package:hired_u_vendor/providers/providers.dart';
import 'package:hired_u_vendor/services/services.dart';
import 'package:hired_u_vendor/utils/utils.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: AppTheme.mainPinkColor,
      body: SafeArea(
          child: Stack(
        clipBehavior: Clip.antiAlias,
        overflow: Overflow.visible,
        // alignment: Alignment.topCenter,
        children: [
          topBar(),
          listView(context),
          personalInfoArea(userProvider == null ? User() : userProvider.user)
        ],
      )),
    );
  }

  Widget topBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Profile",
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget personalInfoArea(User user) {
    return Positioned(
      top: 40,
      left: 50, right: 50,
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 9.0, bottom: 9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: user.profile == null
                      ? AssetImage("assets/avatar.png")
                      : NetworkImage(
                          ApiService.imageBaseURL + user.profile!,
                          // errorBuilder: (context, exception, stacktrace) {
                          //   print("Exception: ${exception.toString()}");
                          //   print("Stacktrace: ${stacktrace.toString()}");
                          //   return Text("Image can't be loaded");
                          // },
                        ) as ImageProvider,
                  radius: 50.0,
                ),
                SizedBox(
                  height: 13.0,
                ),
                Text(user.name == null ? "Osolo" : user.name!),
                SizedBox(
                  height: 9.0,
                ),
                Text(user.email == null ? "email@gmail.com" : user.email!),
                SizedBox(
                  height: 13.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        nextScreen(
                            context,
                            EditProfilePage(
                              user: user,
                            ));
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
      ),
    );
  }

  Widget listView(BuildContext context) {
    return Positioned(
      top: 230,
      left: 0,
      width: response.screenWidth,
      child: Container(
        height: response.screenHeight! * 0.8,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            SizedBox(
              height: 48.0,
            ),
            ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () {
                    nextScreen(context, PaymentList());
                  },
                  child: const ListTile(
                    leading: Icon(Icons.credit_card_outlined),
                    title: Text("Users Payment History"),
                  ),
                ),
                // ListTile(
                //   leading: Icon(Icons.support_agent),
                //   title: Text("Support"),
                // ),
                GestureDetector(
                  onTap: () async {
                    logout(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  logout(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure  you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.mainBlueColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              var result = await ApiService().logout();
              if (result.status) {
                nextFirstScreen(context, const Login());
              } else {
                Navigator.pop(context);
                Flushbar(
                        message:
                            "An unexpected error occured! You can't logout.",
                        title: "Sorry",
                        duration: const Duration(seconds: 4))
                    .show(context);
              }
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

}
