import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({super.key});

  @override
  ExpandableFabState createState() => ExpandableFabState();
}

class ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _translateAnimation;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.75).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _translateAnimation = Tween<double>(begin: 0.0, end: -70.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (_isOpen)
          GestureDetector(
            onTap: _toggle,
            child: Container(
              color: Colors.black54,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _translateAnimation.value * 2),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    // Handle Image button press
                  },
                  heroTag: 'image',
                  icon: const Icon(Icons.image),
                  label: const Text('Image'),
                ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _translateAnimation.value),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    // Handle Text button press
                  },
                  heroTag: 'text',
                  icon: const Icon(Icons.text_fields),
                  label: const Text('Text'),
                ),
              ),
            );
          },
        ),
        FloatingActionButton(
          onPressed: _toggle,
          heroTag: 'main',
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotateAnimation.value * 3.14,
                child: const Icon(Icons.add),
              );
            },
          ),
        ),
      ],
    );
  }
}
