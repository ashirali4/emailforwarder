import 'package:flutter/material.dart';
class ButtonWidget extends StatelessWidget {
  final String buttonText;
  final Function buttonFunction;
  ButtonWidget({Key? key,required this.buttonText,required this.buttonFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),

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
