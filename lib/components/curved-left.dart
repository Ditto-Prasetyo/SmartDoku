import 'package:flutter/material.dart';

class CurvedLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: ClipPath(
        clipper: LeftClipper(),
        child: Container(
          height: 300.0,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(236, 210, 59, 1),
                Color.fromRGBO(248, 174, 62, 1),
                Color.fromRGBO(230, 133, 89, 1),
                Color.fromRGBO(238, 81, 9, 1)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(20, size.height, -25, size.height);
    path.quadraticBezierTo(80, 80, size.width - 140, 70);
    path.quadraticBezierTo(size.width, 65, size.width, -30);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
