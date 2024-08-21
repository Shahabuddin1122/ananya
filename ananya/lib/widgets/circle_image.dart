import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CircleImage extends StatefulWidget {
  final String image;
  bool isHighlighted;
  final String id;
  CircleImage(
      {required this.id,
      required this.isHighlighted,
      required this.image,
      super.key});

  @override
  _CircleImageState createState() => _CircleImageState();
}

class _CircleImageState extends State<CircleImage> {
  void _toggleHighlight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cohort-user', widget.id);
    setState(() {
      widget.isHighlighted = !widget.isHighlighted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleHighlight,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              widget.isHighlighted ? Colors.transparent : Colors.grey,
              widget.isHighlighted ? BlendMode.dst : BlendMode.saturation,
            ),
            child: Image.asset(
              widget.image,
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
