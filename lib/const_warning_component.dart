import 'package:flutter/material.dart';

class ConstWarningComponent extends StatelessWidget {
  const ConstWarningComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Use 'const' with the constructor",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            "Try adding the 'const' keyword to the constructor invocation.",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          Divider(),
          Text(
            "Use 'const' with the ...",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            "Try adding 'const' before the literal.",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

