import 'package:app_settings/app_settings.dart';
import 'package:emailforwarder/src/pages/auth/login.dart';
import 'package:emailforwarder/src/pages/utlis/shared_pref.dart';
import 'package:emailforwarder/src/widgets/button.dart';
import 'package:emailforwarder/src/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


class MainDashboardSreen extends StatefulWidget {
  final Function function;
  final String email;
  const MainDashboardSreen({Key? key,required this.function,required this.email}) : super(key: key);


  @override
  _MainDashboardSreenState createState() => _MainDashboardSreenState();
}

class _MainDashboardSreenState extends State<MainDashboardSreen> with
    AutomaticKeepAliveClientMixin<MainDashboardSreen>{

  TextEditingController controllert=TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {

    controllert.text=widget.email;
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 15,right: 15,top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
              margin: EdgeInsets.only(bottom: 15),
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
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 15),
              margin: EdgeInsets.only(bottom: 15),
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
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Set Status Receive Email'),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    child: TextFieldWidget(
                      name: 'Email',
                      hint: 'Enter your Email',
                      controller: controllert,
                      isPassword: false,
                      icon: Icons.mail_outline_rounded,
                    ),

                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: ButtonWidget(buttonText: 'UPDATE',buttonFunction: () async {
                      EasyLoading.showToast('Email Updated',toastPosition: EasyLoadingToastPosition.bottom);
                      widget.function(this.controllert.text);
                      FocusScope.of(context).unfocus();
                    },radiusmine: 05,),
                  )

                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}
