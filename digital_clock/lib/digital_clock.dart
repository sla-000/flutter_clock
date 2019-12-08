// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/assets.dart';
import 'package:digital_clock/petri_dish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:logging/logging.dart';

final Logger _log = Logger('DigitalClock')..level = Level.FINEST;

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Colors.black54,
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Colors.transparent,
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  final ValueNotifier<int> _H_Notifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _h_Notifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _M_Notifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _m_Notifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    _loggerInit();

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();

    Future<void>(() {
      load();
    });
  }

  void _loggerInit() {
    Logger.root.onRecord.listen((LogRecord rec) {
      debugPrint(
          '${rec.time.minute.toString().padLeft(2, '0')}:'
          '${rec.time.second.toString().padLeft(2, '0')}.'
          '${rec.time.millisecond.toString().padLeft(3, '0')} > ${rec.loggerName}/${rec.level.name}: ${rec.message}'
          '${rec.error == null ? "" : "\n\terror=${rec.error}"}'
          '${rec.stackTrace == null ? "" : "\n\tstacktrace=${rec.stackTrace}"}',
          wrapWidth: 700);
    });

    hierarchicalLoggingEnabled = true;
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
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

    _H_Notifier.dispose();
    _h_Notifier.dispose();
    _M_Notifier.dispose();
    _m_Notifier.dispose();

    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    _dateTime = DateTime.now();

    _log.finest(() => '_updateTime: _dateTime=$_dateTime');

    _H_Notifier.value = (_dateTime.hour / 10).floor();
    _h_Notifier.value = (_dateTime.hour % 10).floor();
    _M_Notifier.value = (_dateTime.minute / 10).floor();
    _m_Notifier.value = (_dateTime.minute % 10).floor();

    _timer = Timer(
      Duration(minutes: 1) -
          Duration(seconds: _dateTime.second) -
          Duration(milliseconds: _dateTime.millisecond),
      _updateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    return Container(
      color: colors[_Element.background],
      child: Row(
        children: <Widget>[
          Expanded(
            child: PetriDish(
              valueNotifier: _H_Notifier,
              calculateFps: true,
              key: const ValueKey<String>('H'),
            ),
          ),
          Expanded(
            child: PetriDish(
              valueNotifier: _h_Notifier,
              key: const ValueKey<String>('h'),
            ),
          ),
          Expanded(
            child: PetriDish(
              valueNotifier: _M_Notifier,
              key: const ValueKey<String>('M'),
            ),
          ),
          Expanded(
            child: PetriDish(
              valueNotifier: _m_Notifier,
              key: const ValueKey<String>('m'),
            ),
          ),
        ],
      ),
    );
  }
}
