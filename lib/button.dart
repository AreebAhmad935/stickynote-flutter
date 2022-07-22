import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final dynamic text;
  final  dynamic function;

  const MyButton({Key? key, this.function, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8),
      child: GestureDetector(
        onTap: function,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            padding: const EdgeInsets.all(15),
            color: Colors.pink[500],
            child: Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}