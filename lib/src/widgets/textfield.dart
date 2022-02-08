import 'package:flutter/material.dart';
class TextFieldWidget extends StatelessWidget {
  final String name;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final IconData icon;
  TextFieldWidget({Key? key,required this.name, required this.hint,required this.controller,
  required this.isPassword, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: TextField(
        autocorrect: false,
        enableSuggestions: false,
        style: TextStyle(
          fontSize: 12
        ),
        controller: this.controller,
        obscureText: this.isPassword,
        decoration:  InputDecoration(
            border:  OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.blue)),
            hintText: this.hint,
            labelText: this.name,
            prefixIcon:  Icon(
              this.icon,
              color: Colors.blue,
            ),
            ),
      ),
    );
  }
}
