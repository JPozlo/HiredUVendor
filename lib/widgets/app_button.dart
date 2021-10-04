import 'package:flutter/material.dart';
import 'package:hired_u_vendor/pages/pages.dart';
import 'package:hired_u_vendor/utils/utils.dart';

enum ButtonType { PRIMARY, PLAIN }

class AppButton extends StatelessWidget {
  final ButtonType type;
  final VoidCallback onPressed;
  final String text;
  final String disabledMessage;
  final bool disabled;

  AppButton(
      {
        required this.type,
      required this.onPressed,
      required this.text,
      this.disabled = false,
      this.disabledMessage = "Disabled"
      });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.disabled
          ? () {
              return showSnackbar(context, this.disabledMessage);
            }
          : this.onPressed,
      child: Container(
        width: double.infinity,
        height: response.setHeight(48.0),
        decoration: BoxDecoration(
          color: getButtonColor(type),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(169, 176, 185, 0.42),
              spreadRadius: 0,
              blurRadius: 8.0,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Center(
          child: Text(
            this.text,
            style: TextStyle(
              color: getTextColor(type),
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    action: SnackBarAction(
      label: "OK",
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  ));
}

Color getButtonColor(ButtonType type) {
  switch (type) {
    case ButtonType.PRIMARY:
      return AppTheme.mainBlueColor;
    case ButtonType.PLAIN:
      return Colors.white;
    default:
      return AppTheme.mainOrangeColor;
  }
}

Color getTextColor(ButtonType type) {
  switch (type) {
    case ButtonType.PLAIN:
      return Colors.black;
    case ButtonType.PRIMARY:
      return Colors.white;
    default:
      return Colors.white;
  }
}
