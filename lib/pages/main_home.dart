import 'package:flutter/material.dart';
import 'package:hired_u_vendor/models/models.dart';
import 'package:hired_u_vendor/pages/home.dart';
import 'package:hired_u_vendor/pages/pages.dart';
import 'package:hired_u_vendor/providers/providers.dart';
import 'package:hired_u_vendor/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:response/response.dart';

var response = ResponseUI.instance;

class MainHome extends StatefulWidget {
  const MainHome({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final PreferenceUtils _sharedPreferences = PreferenceUtils.getInstance();
  int _currentIndex = 0;
  late String userName, userEmail, userToken, userProfile, userPhone, userDevice;

  final screens = [Home(), CreateProductPage(), OrdersScreen(), ProfileScreen()];

  @override
  void initState() {
    super.initState();
        Future.delayed(Duration.zero, () {
      if (widget.user == null) {
        userName =
            _sharedPreferences.getValueWithKey(Constants.userNamePrefKey);
        userEmail =
            _sharedPreferences.getValueWithKey(Constants.userEmailPrefKey);
        userToken =
            _sharedPreferences.getValueWithKey(Constants.userTokenPrefKey);
        userProfile =
            _sharedPreferences.getValueWithKey(Constants.userProfilePrefKey);
        userPhone =
            _sharedPreferences.getValueWithKey(Constants.userPhonePrefKey);
        userDevice = _sharedPreferences
            .getValueWithKey(Constants.userDeviceModelPrefKey);
        print("If place is HIT: $userName");
      } else {
        userName = this.widget.user!.name!;
        userEmail = this.widget.user!.email!;
        userPhone = this.widget.user!.phone ?? "";
        userProfile = this.widget.user!.profile ?? "";
      }
      Provider.of<UserProvider>(context, listen: false).user = User(
          profile: userProfile,
          name: userName,
          phone: userPhone,
          email: userEmail,
          deviceName: userDevice,
          token: userToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: AppTheme.mainDarkBackgroundColor,
        selectedItemColor: AppTheme.mainOrangeColor,
        unselectedItemColor: AppTheme.mainScaffoldBackgroundColor,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            backgroundColor: AppTheme.mainCardBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add Product",
            backgroundColor: AppTheme.mainCardBackgroundColor,
          ),
          //    BottomNavigationBarItem(
          //   icon: Icon(Icons.card_giftcard),
          //   label: "Orders",
          //   backgroundColor: AppTheme.mainCardBackgroundColor,
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
            backgroundColor: AppTheme.mainCardBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
            backgroundColor: AppTheme.mainCardBackgroundColor,
          ),
        ],
      ),
    );
  }
}
