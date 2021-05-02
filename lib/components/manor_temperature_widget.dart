import 'package:flutter/material.dart';

class ManorTemperature extends StatelessWidget {
  final double manorTemp;
  int level;
  final List<Color> temperColor = [
    Color(0xff072038),
    Color(0xff0d3a65),
    Color(0xff186ec0),
    Color(0xff37b24d),
    Color(0xffffad13),
    Color(0xfff76707),
  ];

  ManorTemperature({Key key, this.manorTemp}) {
    _calcTempLevel();
  }

  void _calcTempLevel() {
    if (manorTemp <= 20) {
      level = 0;
    } else if (manorTemp > 20 && manorTemp <= 32) {
      level = 1;
    } else if (manorTemp > 32 && manorTemp <= 36.5) {
      level = 2;
    } else if (manorTemp > 36.5 && manorTemp <= 40) {
      level = 3;
    } else if (manorTemp > 40 && manorTemp <= 50) {
      level = 4;
    } else if (manorTemp > 50) {
      level = 5;
    }
  }

  Widget _makeTempLabelAndBar() {
    return Container(
      width: 70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$manorTemp°C",
            style: TextStyle(
                color: temperColor[level],
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 6,
              color: Colors.black.withOpacity(0.2),
              child: Row(
                children: [
                  Container(
                    height: 6,
                    width: 70/99*manorTemp,
                    color: temperColor[level],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _makeTempLabelAndBar(),
              Container(
                margin: const EdgeInsets.only(left: 7),
                width: 30,
                height: 30,
                child: Image.asset('assets/images/level-$level.jpg'),
              ),
            ],
          ),
          Text(
            "매너온도",
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                decoration: TextDecoration.underline),
          )
        ],
      ),
    );
  }
}
