import 'package:flutter/material.dart';

class MyAnimatedImage extends StatefulWidget {
  @override
  _MyAnimatedImageState createState() => _MyAnimatedImageState();
}

class _MyAnimatedImageState extends State<MyAnimatedImage> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _visible = !_visible;
        });
      },
      child: Stack(
        children: [
          Image.asset(
            'assets/logo.png',
            width: 10,
            height: 10,
          ),
          AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Image.asset(
              'assets/logo.png',
              width: 10,
              height: 10,
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  color: Colors.white.withOpacity(_controller.value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
