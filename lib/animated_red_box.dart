import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SquareAnimation(),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  @override
  _SquareAnimationState createState() => _SquareAnimationState();
}

class _SquareAnimationState extends State<SquareAnimation> {
  double _squarePosition = 0.0;
  bool _isAnimating = false;
  static const _squareSize = 50.0;
  void _moveSquare(double direction) {
    setState(() {
      _isAnimating = true;
      _squarePosition = direction;
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final squareSize = 100.0;
    final maxMoveDistance = (screenWidth - squareSize) / 2;

    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 1),
            transform: Matrix4.translationValues(
              _squarePosition * maxMoveDistance,
              0.0,
              0.0,
            ),
            child: Container(
              width: _squareSize,
              height: _squareSize,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _isAnimating || _squarePosition == -1.0
                    ? null
                    : () => _moveSquare(-1.0),
                child: Text('Left'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: _isAnimating || _squarePosition == 1.0
                    ? null
                    : () => _moveSquare(1.0),
                child: Text('Right'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
