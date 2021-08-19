import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Home.png'),
          fit: BoxFit.cover,
        ),
      ),
      //child: CircularProgressIndicator.adaptive(),
    );
  }
}
