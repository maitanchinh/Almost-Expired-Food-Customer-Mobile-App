import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class AccountComponent extends StatelessWidget {
  final String icon;
  final Color? greyColor;
  final Color? iconColor;
  final String content;
  final VoidCallback? callBack;

  const AccountComponent({
    Key? key,
    required this.icon,
    required this.content,
    this.greyColor,
    this.callBack,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callBack,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: greyColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform.scale(
                      scale: 0.8,
                      child: Image.asset(icon)
                    ),
                  ),
                ),
                10.width,
                Text(
                  content,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
             SizedBox(
              width: 24,
              child: Icon(Icons.arrow_forward_outlined),
            ),
          ],
        ),
      ),
    );
  }
}