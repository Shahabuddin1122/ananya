import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final String image;
  bool isHighlighted;
  final String id;
  final ValueChanged<String> onSelect;
  CircleImage(
      {required this.id,
      required this.isHighlighted,
      required this.image,
      required this.onSelect,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(id),
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
              isHighlighted ? Colors.transparent : Colors.grey,
              isHighlighted ? BlendMode.dst : BlendMode.saturation,
            ),
            child: Image.asset(
              image,
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
