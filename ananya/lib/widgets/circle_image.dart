import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final String image;
  bool isHighlighted;
  final String id;
  final String anomalies;
  final ValueChanged<String> onSelect;
  CircleImage(
      {required this.id,
      required this.anomalies,
      required this.isHighlighted,
      required this.image,
      required this.onSelect,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(id),
      child: Stack(
        children: [
          Container(
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
          Positioned(
            right: 0,
            bottom: 5,
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: anomalies == 'Regular'
                      ? Colors.lightGreenAccent
                      : Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
        ],
      ),
    );
  }
}
