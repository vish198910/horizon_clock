// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:horizon_clock/clock_dial.dart';
import 'package:horizon_clock/date_card.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'drawn_hand.dart';
import 'package:weather_icons/weather_icons.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

enum _Element {
  background,
  text,
  shadow,
}

class WeatherMoodIcons extends StatelessWidget {
  IconData weatherMood;
  double size;
  Color colorData;
  WeatherMoodIcons({this.weatherMood, this.size, this.colorData});

  @override
  Widget build(BuildContext context) {
    return Icon(
      weatherMood,
      size: size,
      color: colorData,
    );
  }
}

final date = [
  DateCard(
    size: 50.0,
    dateTime: DateTime.now(),
  )
];
/*
final _lightTheme = {
  _Element.background: Color(0xFF000000),
  _Element.text: Color(0xFF03DAC6),
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Color(0xFF03DAC6),
  _Element.shadow: Color(0xFF174EA6),
};
*/

/// A basic analog clock.
///
/// You can do better than this!
class HorizonClock extends StatefulWidget {
  const HorizonClock(this.model);

  final ClockModel model;

  @override
  _HorizonClockState createState() => _HorizonClockState();
}

class _HorizonClockState extends State<HorizonClock>
    with SingleTickerProviderStateMixin {
  var _dateTime = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = WeatherCondition.cloudy.toString();
  var _location = '';
  Timer _timer;
  static double size = 100;
  static Color color = Color(0xFF03DAC6);
  final weatherIcons = [
    WeatherMoodIcons(
      weatherMood: WeatherIcons.day_sunny,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.day_showers,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.day_windy,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.day_fog,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.day_snow,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.day_cloudy,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.day_thunderstorm,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.night_showers,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.night_snow,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.night_cloudy,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.night_fog,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.night_clear,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.night_thunderstorm,
      size: size,
      colorData: color,
    ),
    WeatherMoodIcons(
      weatherMood: WeatherIcons.night_cloudy_windy,
      size: size,
      colorData: color,
    ),
    SizedBox(
      height: 20,
      width: 20.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    print(_condition);
    _updateTime();
    _updateModel();
    _updateWeather();
  }

  @override
  void didUpdateWidget(HorizonClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      //Now this updating every minute
      _timer = Timer(
        Duration(seconds: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  int _updateWeather() {
    //for the night and the evening time
    int code = 0;
    setState(() {});
    if (_dateTime.hour > 18 || _dateTime.hour > 6) {
      if (_condition == WeatherCondition.cloudy.toString()) {
        code = 9;
      } else if (_condition == WeatherCondition.foggy.toString()) {
        code = 10;
      } else if (_condition == WeatherCondition.rainy.toString()) {
        code = 7;
      } else if (_condition == WeatherCondition.thunderstorm.toString()) {
        code = 12;
      } else if (_condition == WeatherCondition.snowy.toString()) {
        code = 8;
      } else if (_condition == WeatherCondition.windy.toString()) {
        code = 8;
      }
    } else if (_dateTime.hour <= 18 || _dateTime.hour <= 6) {
      if (_condition == WeatherCondition.cloudy.toString()) {
        code = 5;
      } else if (_condition == WeatherCondition.foggy.toString()) {
        code = 3;
      } else if (_condition == WeatherCondition.thunderstorm.toString()) {
        code = 6;
      } else if (_condition == WeatherCondition.snowy.toString()) {
        code = 4;
      } else if (_condition == WeatherCondition.sunny.toString()) {
        code = 0;
      } else if (_condition == WeatherCondition.rainy.toString()) {
        code = 1;
      } else if (_condition == WeatherCondition.windy.toString()) {
        code = 13;
      }
    }

    return code;
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            primaryColor: Color(0xFFBB86FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF03DAC6),
            backgroundColor: Colors.blueGrey.shade500,
          )
        : Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Color(0xFF6200EE),
            // Minute hand.
            highlightColor: Color(0xFF41C300),
            // Second hand.
            accentColor: Color(0xFF03DAC6),
            backgroundColor: Color(0xFF000000),
          );

    final time = DateFormat.Hms().format(DateTime.now());
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: customTheme.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_temperature),
          Text(_temperatureRange),
          Text(_condition),
          Text(_location),
        ],
      ),
    );

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: customTheme.backgroundColor,
        ),
        child: Stack(
          children: [
// Example of a hand drawn with [CustomPainter].
            new Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(10.0),
              child: new CustomPaint(
                painter: new ClockDialPainter(),
              ),
            ),

            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 1.5,
                decoration: BoxDecoration(
                  gradient: RadialGradient(colors: [
                    customTheme.accentColor,
                    customTheme.backgroundColor,
                    customTheme.accentColor,
                    customTheme.accentColor,
                    customTheme.backgroundColor,
                    customTheme.accentColor,
                  ]),
                  shape: BoxShape.circle,
                  color: customTheme.backgroundColor,
                ),
              ),
            ),

            DrawnHand(
                color: customTheme.backgroundColor,
                thickness: 5,
                size: 0.4,
                angleRadians: _dateTime.minute * radiansPerTick),
            DrawnHand(
              color: customTheme.backgroundColor,
              thickness: 4,
              size: 0.8,
              angleRadians: _dateTime.second * radiansPerTick,
            ),
            DrawnHand(
              color: customTheme.backgroundColor,
              thickness: 16,
              size: 0.5,
              angleRadians: _dateTime.hour * radiansPerHour +
                  (_dateTime.minute / 60) * radiansPerHour,
            ),
// Example of a hand drawn with [Container].

            Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: customTheme.backgroundColor,
                ),
              ),
            ),

            Container(
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 1.55),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: weatherIcons[_updateWeather()]),
                    Expanded(
                      child: DateCard(
                        dateTime: _dateTime,
                        size: 50,
                        color1: customTheme.accentColor,
                        color2: customTheme.backgroundColor,
                      ),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 1.55),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        "Min: ${widget.model.low}°C\nMax: ${widget.model.highString}",
                        style: TextStyle(
                            color: customTheme.accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Text("$_location",
                        style: TextStyle(
                            color: customTheme.accentColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
