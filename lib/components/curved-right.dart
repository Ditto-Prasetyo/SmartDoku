import 'package:flutter/material.dart';

class CurvedRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: ClipPath(
        clipper: RightClipper(),
        child: Container(
          height: 250.0,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromRGBO(110, 198, 236, 1),
                Color.fromRGBO(111, 204, 247, 1),
                Color.fromRGBO(84, 181, 245, 1),
                Color.fromRGBO(11, 173, 248, 1)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(35, size.height);
    path.quadraticBezierTo(
      0,
      size.height,
      0,
      size.height,
    );
    path.quadraticBezierTo(
      size.width - 70,
      size.height - 70,
      size.width - 15,
      35,
    );
    path.quadraticBezierTo(
      size.width - 5,
      10,
      size.width,
      0,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(35, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
