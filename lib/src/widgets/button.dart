import 'package:flutter/material.dart';
class ButtonWidget extends StatelessWidget {
  final String buttonText;
  final Function buttonFunction;
  final double radiusmine;
  ButtonWidget({Key? key,required this.buttonText,required this.buttonFunction,this.radiusmine=10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(this.radiusmine),

          ),
        ),
      ),
      child: Text(this.buttonText),
      onPressed: () {
        this.buttonFunction();
      },
    );
  }
}
