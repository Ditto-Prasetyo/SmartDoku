import 'package:smart_doku/pages/auth/login_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.indigo,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(),
              height: height * 0.25,
              width: width,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.sort,
                            color: Color.fromRGBO(255, 255, 255, 1),
                            size: 40,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(4.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255, 255, 255, 0.3),
                            border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.1))
                            
                          ),
                          child: Icon(
                            Icons.people_outline_rounded,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: height * 0.75,
              width: width,
            ),
          ],
        ),
      ),
    );
  }
}
