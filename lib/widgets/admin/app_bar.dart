// import 'package:flutter/material.dart';

// class CustomAppBar extends StatelessWidget {
//   final String title;
//   final VoidCallback onBackPressed;

//   const CustomAppBar({
//     Key? key,
//     required this.title,
//     required this.onBackPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: onBackPressed,
//               child: const CircleAvatar(
//                 backgroundColor: Colors.white54,
//                 child: Icon(Icons.arrow_back, color: Colors.black),
//               ),
//             ),
//             Text(title, style: const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 18)),
//             const SizedBox(width: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }
