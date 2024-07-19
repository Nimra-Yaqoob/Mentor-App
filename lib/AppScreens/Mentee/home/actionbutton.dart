// import 'package:flutter/material.dart';

// class ActionButton extends StatelessWidget {
//   final IconData iconData;
//   final String label;
//   final Color backgroundColor, iconColor, textColor;

//   const ActionButton(
//       {required this.iconData,
//       required this.label,
//       required this.backgroundColor,
//       required this.iconColor,
//       required this.textColor, required Null Function() onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
//         decoration: BoxDecoration(
//             color: backgroundColor, borderRadius: BorderRadius.circular(15)),
//         child: Row(children: [
//           Icon(iconData, color: iconColor),
//           SizedBox(width: 5),
//           Text(label, style: TextStyle(color: textColor))
//         ]));
//   }
// }

import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Color backgroundColor, iconColor, textColor;
  final VoidCallback? onTap; // Add onTap callback

  const ActionButton({
    required this.iconData,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call onTap callback when pressed
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(iconData, color: iconColor),
            SizedBox(width: 5),
            Text(label, style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }
}
