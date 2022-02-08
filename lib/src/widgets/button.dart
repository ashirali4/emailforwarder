import 'package:flutter/material.dart';
class ButtonWidget extends StatelessWidget {
  final String buttonText;
  final Function buttonFunction;
  final double radiusmine;
  final Color color;
  ButtonWidget({Key? key,required this.buttonText,required this.buttonFunction,this.radiusmine=10,
  this.color=Colors.blue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
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
