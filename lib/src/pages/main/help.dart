import 'package:emailforwarder/src/pages/utlis/strings.dart';
import 'package:flutter/material.dart';
class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 10,left: 15,right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings),
                SizedBox(width: 10,),
                Text('Help Contents:',style: TextStyle(
                    fontSize: 22
                ),),
              ],
            ),
            SizedBox(height: 15,),
            HeadText(helping_strings[0]),
            DescText(helping_strings[1]),
            SizedBox(height: 15,),
            HeadText(helping_strings[2]),
            DescText(helping_strings[3]),
            DescText(helping_strings[4]),
            DescText(helping_strings[5]),
            SizedBox(height: 05,),
            HeadText(helping_strings[6]),
            DescText(helping_strings[7]),
            DescText(helping_strings[8]),
            HeadText(helping_strings[9]),
            DescText(helping_strings[10]),
            DescText(helping_strings[11]),
            DescText(helping_strings[12]),
            DescText(helping_strings[13]),
            DescText(helping_strings[14]),
            DescText(helping_strings[15]),
            DescText(helping_strings[16]),
            DescText(helping_strings[17]),

          ],
        ),
      ),
    );
  }

  Widget HeadText(String text){
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Text(text,style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold
      ),),
    );
  }


  Widget DescText(String text){
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Text(text));
  }
}
