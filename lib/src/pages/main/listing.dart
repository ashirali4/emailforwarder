import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class ListingSection extends StatefulWidget {
  const ListingSection({Key? key}) : super(key: key);

  @override
  _ListingSectionState createState() => _ListingSectionState();
}

class _ListingSectionState extends State<ListingSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40,right: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height:120,
            child:Lottie.asset('assets/working.json'),
          ),
          SizedBox(height: 20,),
          Text('We are working on history! Keep Patience',style: TextStyle(
              fontSize: 18
          ),
          textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}
