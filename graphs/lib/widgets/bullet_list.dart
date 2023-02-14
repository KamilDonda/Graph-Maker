import 'package:flutter/material.dart';

class BulletList extends StatelessWidget {
  final List<String> strings;

  const BulletList(this.strings, {super.key});

  final double fontSize = 15;
  final double height = 1.4;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: strings.map((str) {
          return Container(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u2022',
                  style: TextStyle(
                    fontSize: fontSize,
                    height: height,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    str,
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black.withOpacity(0.6),
                      height: height,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
