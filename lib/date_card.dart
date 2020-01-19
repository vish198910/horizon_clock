import "package:flutter/material.dart";

class DateCard extends StatelessWidget {
  final DateTime dateTime;
  final double size;
  final Color color1;
  final Color color2;
  DateCard({this.dateTime, this.size,this.color1,this.color2});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: size * 2,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
                colors: [color1, color2, color1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
              width: 10.0,
            ),
            Text(
              "${dateTime.day}/${dateTime.month}/${dateTime.year}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: color1),
            ),
            SizedBox(
              height: 10.0,
              width: 10.0,
            ),
            Text(
              "${weekDay()}",
              style: TextStyle(
                  color: color1,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  String weekDay() {
    switch (dateTime.weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "Not in a week";
    }
  }
}
