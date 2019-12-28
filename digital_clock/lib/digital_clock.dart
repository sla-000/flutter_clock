// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/petri_dish.dart';
import 'package:digital_clock/utils/assets.dart';
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
  final ValueNotifier<int> _hHNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _hLNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _mHNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _mLNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    _loggerInit();

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();

    Future<void>(() {
      Assets.instance.load();
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

    _hHNotifier.dispose();
    _hLNotifier.dispose();
    _mHNotifier.dispose();
    _mLNotifier.dispose();

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

    _hHNotifier.value = (_dateTime.hour / 10).floor();
    _hLNotifier.value = (_dateTime.hour % 10).floor();
    _mHNotifier.value = (_dateTime.minute / 10).floor();
    _mLNotifier.value = (_dateTime.minute % 10).floor();

    _timer = Timer(
      Duration(minutes: 1) -
          Duration(seconds: _dateTime.second) -
          Duration(milliseconds: _dateTime.millisecond),
      _updateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FourDigitsWidget(
          hHNotifier: _hHNotifier,
          hLNotifier: _hLNotifier,
          mHNotifier: _mHNotifier,
          mLNotifier: _mLNotifier,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Opacity(
            opacity: 0.5,
            child: FloatingActionButton(
              mini: true,
              child: Icon(Icons.refresh),
              onPressed: () => setState(() {}),
            ),
          ),
        )
      ],
    );
  }
}

class FourDigitsWidget extends StatelessWidget {
  const FourDigitsWidget({
    @required this.hHNotifier,
    @required this.hLNotifier,
    @required this.mHNotifier,
    @required this.mLNotifier,
  });

  final ValueNotifier<int> hHNotifier;
  final ValueNotifier<int> hLNotifier;
  final ValueNotifier<int> mHNotifier;
  final ValueNotifier<int> mLNotifier;

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
              valueNotifier: hHNotifier,
              calculateFps: true,
              name: '1',
              key: const ValueKey<String>('H'),
            ),
          ),
          Expanded(
            child: PetriDish(
              valueNotifier: hLNotifier,
              name: '2',
              key: const ValueKey<String>('h'),
            ),
          ),
          Expanded(
            child: PetriDish(
              valueNotifier: mHNotifier,
              name: '3',
              key: const ValueKey<String>('M'),
            ),
          ),
          Expanded(
            child: PetriDish(
              valueNotifier: mLNotifier,
              name: '4',
              key: const ValueKey<String>('m'),
            ),
          ),
        ],
      ),
    );
  }
}
