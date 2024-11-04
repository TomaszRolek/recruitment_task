import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final String title;
  final Color? backgroundColor;

  const Tile({
    Key? key,
    required this.title,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: backgroundColor == Colors.green ? 200 : 150,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: backgroundColor == Colors.green ? Colors.black.withOpacity(0.2) : Colors.transparent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
      const Positioned(right: 8, top: 8, child: Icon(Icons.favorite_border, color: Colors.white)),
    ]);
  }
}
