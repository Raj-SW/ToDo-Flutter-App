// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:devstack/constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatefulWidget {
  final String? text;
  final Function()? press;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: newElevatedButton(),
      ),
    );
  }

  //Used:ElevatedButton as FlatButton is deprecated.
  Widget newElevatedButton() {
    return ElevatedButton(
      child: Text(
        widget.text!,
        style: TextStyle(color: widget.textColor),
      ),
      onPressed: widget.press,
      style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: TextStyle(
              color: widget.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500)),
    );
  }
}
