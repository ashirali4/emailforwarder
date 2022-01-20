import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
class MainDashboardSreen extends StatefulWidget {
  const MainDashboardSreen({Key? key}) : super(key: key);

  @override
  _MainDashboardSreenState createState() => _MainDashboardSreenState();
}

class _MainDashboardSreenState extends State<MainDashboardSreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15,right: 15,top: 15),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(2, 4), // Shadow position
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height:120,
                  child:Lottie.asset('assets/email.json'),
                ),
                Expanded(child: Column(children: [
                  Text('Email to SMS is working...',style: TextStyle(
                    fontSize: 18
                  ),),
                  Text('You can use below settings to control the application',style: TextStyle(
                      fontSize: 14
                  ),),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,))
              ],
            ),
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              Icon(Icons.settings),
              SizedBox(width: 10,),
              Text('Settings',style: TextStyle(
                  fontSize: 22
              ),),
            ],
          ),
          SizedBox(height: 15,),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(1, 2), // Shadow position
                ),
              ],
            ),
            child: ListTile(
              title: const Text('Change Default SIM Settings'),
              tileColor: Colors.transparent,
              onTap: AppSettings.openDeviceSettings,
                trailing: Icon(Icons.arrow_forward_ios_sharp) // for Left
            ),
          ),
        ],
      ),
    );
  }
}
