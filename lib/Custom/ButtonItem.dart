import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonItem extends StatelessWidget {
  const ButtonItem(
      {Key? key,
      this.imagePath,
    this.onClick,
    this.text,
     this.iconData,
      this.size})
      : super(key: key);
  final String? text;
  final String? imagePath;
  final VoidCallback? onClick;
  final IconData? iconData;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 60,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey, width: 50),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  imagePath!,
                  height: size,
                  width: size,
                ),
                Text(
                  text!,
                  style: TextStyle(fontSize: 17, color: Colors.black),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
