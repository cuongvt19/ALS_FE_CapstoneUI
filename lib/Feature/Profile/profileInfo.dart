import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    Key? key,
    required this.name,
    this.image,
  }) : super(key: key);
  final String name;
  final String? image;

  @override
  Widget build(BuildContext context) {
    //double defaultSize = SizeConfig.defaultSize;
    return SizedBox(
      height: 240,
      child: Stack(
        children: [
          ClipPath(
            clipper: CustomeShape(),
            child: Container(
              height: 150,
              color: Colors.green,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 8,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/logo_Avatar.jpg"),
                    ),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomeShape extends CustomClipper<Path> {
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }
}
