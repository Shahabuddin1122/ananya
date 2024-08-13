import 'package:flutter/material.dart';

class CircleImage extends StatefulWidget {
  final String image;
  const CircleImage({required this.image, super.key});

  @override
  _CircleImageState createState() => _CircleImageState();
}

class _CircleImageState extends State<CircleImage> {
  bool _isHighlighted = false;

  void _toggleHighlight() {
    setState(() {
      _isHighlighted = !_isHighlighted;
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
              _isHighlighted ? Colors.transparent : Colors.grey,
              _isHighlighted ? BlendMode.dst : BlendMode.saturation,
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
