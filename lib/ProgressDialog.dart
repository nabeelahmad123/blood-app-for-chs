import 'package:flutter/material.dart';

class BrandColors {
  static const Color colorPrimary = Color(0xFF2B1A64);
  static const Color colorPrimaryDark = Color(0xFF1c3aa9);
  static const Color colorAccent = Color(0xFF21ba45);
  static const Color colorAccent1 = Color(0xFFe3fded);
  static const Color colorblue = Color(0x22193F);

  static const Color colorBackground = Color(0xFFFBFAFF);

  static const Color colorPink = Color(0xFFE66C75);
  static const Color colorOrange = Color(0xFFE8913A);
  static const Color colorBlue = Color(0xFF2254A3);
  static const Color colorAccentPurple = Color(0xFF4f5cd1);

  static const Color colorText = Color(0xFF383635);
  static const Color colorTextLight = Color(0xFF918D8D);
  static const Color colorTextSemiLight = Color(0xFF737373);
  static const Color colorTextDark = Color(0xFF292828);

  static const Color colorGreen = Color(0xFF40cf89);
  static const Color colorLightGray = Color(0xFFe2e2e2);
  static const Color colorLightGrayFair = Color(0xFFe1e5e8);
  static const Color colorDimText = Color(0xFFadadad);
}

class ProgressDialog extends StatelessWidget {
  final String status;
  ProgressDialog({this.status});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(BrandColors.colorAccent),
              ),
              SizedBox(
                width: 25.0,
              ),
              Text(
                status,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
