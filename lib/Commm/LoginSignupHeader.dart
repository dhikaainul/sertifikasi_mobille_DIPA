import 'package:flutter/material.dart';

class LoginSignupHeader extends StatelessWidget {
  String headerName;

  LoginSignupHeader(this.headerName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 100.0),
          Text(
            headerName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 28.0),
          ),
          SizedBox(height: 10.0),
          Image.asset(
            "assets/images/education-cost.png",
            height: 150.0,
            width: 150.0,
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
