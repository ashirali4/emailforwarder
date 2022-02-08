import 'package:app_settings/app_settings.dart';
import 'package:emailforwarder/src/pages/utlis/swtich.dart';
import 'package:emailforwarder/src/provider.dart';
import 'package:emailforwarder/src/widgets/button.dart';
import 'package:emailforwarder/src/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
class ListingSection extends StatefulWidget {
  const ListingSection({Key? key}) : super(key: key);

  @override
  _ListingSectionState createState() => _ListingSectionState();
}

class _ListingSectionState extends State<ListingSection> {
  TextEditingController emailCn=TextEditingController();
  TextEditingController passwordCn=TextEditingController();
  TextEditingController statusEmail=TextEditingController();

  TextEditingController phonebgin=TextEditingController();
  TextEditingController phoneend=TextEditingController();
  TextEditingController bodybegin=TextEditingController();
  TextEditingController bodyend=TextEditingController();
  TextEditingController imapserver=TextEditingController();
  TextEditingController port=TextEditingController();


  AuthModel? _authModel;



  bool sendStatusOnEmailSend =false;
  bool sendStatusOnEmailFailure = false;
  bool isloggedIn=false;
  bool isSecure=true;

  @override
  void initState() {
    _authModel = Provider.of<AuthModel>(context, listen: false);
    sendStatusOnEmailFailure=_authModel!.sendEmailinFAILURE;
    sendStatusOnEmailSend= _authModel!.sendEmailinSENT;
    isSecure = _authModel!.isSecure;
    emailCn.text=_authModel!.email;
    passwordCn.text=_authModel!.password;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Consumer<AuthModel>(
        builder: (_, model, child) {

          isloggedIn = model.isLoggedIn;
          imapserver.text=model.imapServer;
          port.text=model.imapport;
          phonebgin.text= model.phoneStart;
          phoneend.text=model.phoneEnd;
          bodybegin.text=model.bodyStart;
          bodyend.text=model.bodyEnd;
          statusEmail.text=model.statuemail;


          return Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
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
                EmailPassowrdLogin(),
                StatusSetSettings(),
                KeywordsSettings(),
              ],
            ),
          );
        },
        child: SizedBox(height: 10,),
      ),
    );

  }

  _showDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content:  Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFieldWidget(
                    name: 'IMAP Server',
                    hint: 'Enter your server',
                    controller: imapserver,
                    isPassword: false,
                    icon: Icons.settings,
                  ),
                  SizedBox(height: 10,),
                  TextFieldWidget(
                    name: 'IMAP Port',
                    hint: 'Enter your port',
                    controller: port,
                    isPassword: false,
                    icon: Icons.portrait_sharp,
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.check),
                            SizedBox(width: 10,),
                            Expanded(child: Text('Secure?',style: TextStyle(fontWeight: FontWeight.w700),)),
                          ],
                        ),
                      ),
                      Container(
                          width: 50,
                          child: CustomSwitch(
                            value: isSecure,
                            onChanged: (bool val) {
                              setState(() {
                                isSecure = val;
                              });
                            },
                          )
                      )
                    ],
                  ),
                  SizedBox(height: 15,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: ButtonWidget(buttonText: isloggedIn?'Logged In, tap to Logout.':'Manual Login',buttonFunction: () async {
                      if(isloggedIn){
                        await _authModel!.logOut();
                      }else{
                        if(emailCn!=null && emailCn.text!='' && passwordCn!=null && passwordCn.text!=''){
                          await _authModel!.saveLogin(emailCn.text,passwordCn.text,true);
                        }else{
                          EasyLoading.showToast('Enter Email & Password ',toastPosition: EasyLoadingToastPosition.bottom);

                        }
                      }
                      Navigator.pop(context);
                      FocusScope.of(context).unfocus();
                    },radiusmine: 05,color: isloggedIn?Colors.green:Colors.red,),
                  ),

                ],
              ),
              actions: <Widget>[
                FlatButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                FlatButton(
                    child: const Text('Save'),
                    onPressed: () async {
                      await _authModel!.saveManualConfigurations(imapserver.text,port.text,isSecure);
                      Navigator.pop(context);
                    })
              ],
            );
      },
    );
  });
  }


  Widget EmailPassowrdLogin(){
    return Container(
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
            Text('Gateway Email Account Settings'),
            SizedBox(height: 10,),
            Container(
              height: 50,
              child: TextFieldWidget(
                name: 'Email',
                hint: 'Enter your Email',
                controller: emailCn,
                isPassword: false,
                icon: Icons.mail_outline_rounded,
              ),

            ),
            SizedBox(height: 10,),
            Container(
              height: 50,
              child: TextFieldWidget(
                name: 'Password',
                hint: 'Enter your Password',
                controller: passwordCn,
                isPassword: true,
                icon: Icons.password,
              ),

            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: ButtonWidget(buttonText: isloggedIn?'Logged In, tap to Logout.':'Login',buttonFunction: () async {
                if(isloggedIn){
                  await _authModel!.logOut();
                }else{
                  if(emailCn!=null && emailCn.text!='' && passwordCn!=null && passwordCn.text!=''){
                    await _authModel!.saveLogin(emailCn.text,passwordCn.text,false);
                  }else{
                    EasyLoading.showToast('Enter Email & Password',toastPosition: EasyLoadingToastPosition.bottom);

                  }
                }
                FocusScope.of(context).unfocus();
              },radiusmine: 05,color: isloggedIn?Colors.green:Colors.red,),
            ),

            SizedBox(height: 15,),
            InkWell(
              onTap: (){
                _showDialog();
              },
              child: Center(
                child: Text('Set the Manual Fallback Configurations',style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue
                ),),
              ),
            ),
            SizedBox(height: 10,),


          ],
        )
    );
  }



  Widget StatusSetSettings(){
    return Container(
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
            SizedBox(height: 10,),
            Text('Status Email Settings'),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.check),
                      SizedBox(width: 10,),
                      Expanded(child: Text('Send Status Email when SMS SENT',style: TextStyle(fontWeight: FontWeight.w700),)),
                    ],
                  ),
                ),
                Container(
                    width: 50,
                    child: CustomSwitch(
                      value: sendStatusOnEmailSend,
                      onChanged: (bool val) {
                        setState(() {
                          sendStatusOnEmailSend = val;
                        });
                      },
                    )
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.clear),
                      SizedBox(width: 10,),
                      Expanded(child: Text('Send Status Email on Failure',style: TextStyle(fontWeight: FontWeight.w700),)),
                    ],
                  ),
                ),
                Container(
                    width: 50,
                    child: CustomSwitch(
                      value: sendStatusOnEmailFailure,
                      onChanged: (bool val) {
                        setState(() {
                          sendStatusOnEmailFailure = val;
                        });
                      },
                    )
                )
              ],
            ),
            SizedBox(height: 20,),

            Container(
              height: 50,
              child: TextFieldWidget(
                name: 'Email',
                hint: 'Enter your Email',
                controller: statusEmail,
                isPassword: false,
                icon: Icons.mail_outline_rounded,
              ),

            ),
            SizedBox(height: 10,),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: ButtonWidget(buttonText: 'Update',buttonFunction: () async {
                await _authModel!.saveEmailStat(statusEmail.text, sendStatusOnEmailSend, sendStatusOnEmailFailure);
                EasyLoading.showToast('Settings Updated',toastPosition: EasyLoadingToastPosition.bottom);
                FocusScope.of(context).unfocus();
              },radiusmine: 05,),
            )

          ],
        )
    );
  }



  Widget KeywordsSettings(){
    return Container(
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
            SizedBox(height: 10,),
            Text('Keywords Settings'),
            SizedBox(height: 10,),

            Container(
              height: 50,
              child: TextFieldWidget(
                name: 'Number Keyword Begin',
                hint: 'Number Keyword Begin',
                controller: phonebgin,
                isPassword: false,
                icon: Icons.mail_outline_rounded,
              ),

            ),
            SizedBox(height: 10,),
            Container(
              height: 50,
              child: TextFieldWidget(
                name: 'Number Keyword End',
                hint: 'Number Keyword End',
                controller: phoneend,
                isPassword: false,
                icon: Icons.mail_outline_rounded,
              ),

            ),
            SizedBox(height: 10,),
            Container(
              height: 50,
              child: TextFieldWidget(
                name: 'SMS Body Keyword Begin',
                hint: 'SMS Body Keyword Begin',
                controller: bodybegin,
                isPassword: false,
                icon: Icons.mail_outline_rounded,
              ),

            ),
            SizedBox(height: 10,),
            Container(
              height: 50,
              child: TextFieldWidget(
                name: 'SMS Body Keyword End',
                hint: 'SMS Body Keyword End',
                controller: bodyend,
                isPassword: false,
                icon: Icons.mail_outline_rounded,
              ),

            ),
            SizedBox(height: 10,),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: ButtonWidget(buttonText: 'Update',buttonFunction: () async {
                await _authModel!.saveKeywords(phonebgin.text,phoneend.text,bodyend.text,bodyend.text);
                EasyLoading.showToast('Keywords Updated',toastPosition: EasyLoadingToastPosition.bottom);
                FocusScope.of(context).unfocus();
              },radiusmine: 05,),
            )

          ],
        )
    );
  }




}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key? key,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

