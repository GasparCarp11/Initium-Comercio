import 'package:flutter/material.dart';
import 'package:linear_gradient/linear_gradient.dart';

class GradientBack extends StatelessWidget {
  GradientBack({Key key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidht = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidht,
      height: screenHeight,
      decoration: BoxDecoration(
          gradient: LinearGradientStyle.linearGradient(
        orientation: LinearGradientStyle.ORIENTATION_HORIZONTAL,
        gradientType: LinearGradientStyle.GRADIENT_TYPE_DARK_OCEAN,
      )),
    );
  }
}
