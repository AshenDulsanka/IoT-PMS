import 'dart:async';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter/material.dart';

class Rul extends StatefulWidget {
  const Rul({super.key});

  @override
  _RulState createState() => _RulState();
}

class _RulState extends State<Rul> {
  double _remainingLife = 100.0;
  Timer? _timer;

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(hours: 1), (timer) {
      setState(() {
        _remainingLife = (_remainingLife - 0.1).clamp(0.0, 100.0);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    String status;
    if (_remainingLife < 20.0) {
      status = "Status: Low Remaining Useful Life";
    } else {
      status = "Status: Normal";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Existing AppBar code
      ),
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        child: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 150.0, 20.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Image(
                    image: AssetImage("assets/rul.png"),
                    width: 200,
                    height: 200,
                    alignment: Alignment.topCenter,
                  ),
                  const SizedBox(height: 60),
                  Text(
                    "${_remainingLife.toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
