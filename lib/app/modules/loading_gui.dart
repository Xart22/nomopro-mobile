import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingGui extends StatelessWidget {
  const LoadingGui({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF4d97ff),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitThreeInOut(
            color: Colors.white,
            size: 50.0,
          ),
          SizedBox(height: 20),
          Text(
            "Loading...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
