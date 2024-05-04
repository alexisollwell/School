import 'dart:async';
import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final int timeMinute;
  final void Function() close;
  const Counter({super.key, required this.close, required this.timeMinute});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late int _secondsRemaining;
  Timer? _timer;

  void _startTimer() {
    _secondsRemaining = widget.timeMinute * 60;
    _timer?.cancel(); // Cancela cualquier timer anterior antes de iniciar uno nuevo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        widget.close();
        timer.cancel(); // Detiene el timer
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Asegura que el timer se cancele cuando el widget se desmonte
    super.dispose();
  }

  String _formatSeconds(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    return "$formattedHours:$formattedMinutes:$formattedSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Text(_formatSeconds(_secondsRemaining));
  }
}