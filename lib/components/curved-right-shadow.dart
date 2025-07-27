import 'package:flutter/material.dart';

class CurvedRightShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: ClipPath(
        clipper: RightShadowClipper(),
        child: Container(
          height: 270.0,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromRGBO(86, 201, 251, 0.3),
                Color.fromRGBO(76, 170, 251, 0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RightShadowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(20, size.height);
    path.quadraticBezierTo(0, size.height + 0, -85, size.height + 10);
    path.quadraticBezierTo(
      size.width - 65,
      size.height - 80,
      size.width - 20,
      40,
    );
    path.quadraticBezierTo(size.width, 0, size.width, 10);
    path.lineTo(size.width, size.height);
    path.lineTo(20, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
