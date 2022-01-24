import 'package:emailforwarder/src/pages/dashboard.dart';
import 'package:emailforwarder/src/widgets/button.dart';
import 'package:emailforwarder/src/widgets/textfield.dart';
import 'package:enough_mail/discover/discover.dart';
import 'package:enough_mail/mail/mail_account.dart';
import 'package:enough_mail/mail/mail_client.dart';
import 'package:enough_mail/mail/mail_events.dart';
import 'package:enough_mail/mail/mail_exception.dart';
import 'package:enough_mail/mail_address.dart';
import 'package:enough_mail/message_builder.dart';
import 'package:enough_mail/mime_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:telephony/telephony.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController controller= TextEditingController();
  TextEditingController pasword= TextEditingController();

  final telephony = Telephony.instance;
  MailLoadEvent? myevent;
  String myphone='';
  String mymessage='';
  String mailsender='muhammadashirali4@gmail.com';
  String mailshow='';

  void emailUpdate(String mail){
    setState(() {
      mailsender=mail;
      mailshow=mail;
    });
  }

  void messageFetch(){
    var message=completeMimeMessage?.parts?[1].decodeTextHtmlPart()?.toString();
    var start = "NUMBERSTART--";
    var end = "--NUMBEREND";
    var startIndex = message.toString().indexOf(start);
    var endIndex = message.toString().indexOf(end, startIndex + start.length);
    myphone = message.toString().substring(startIndex + start.length, endIndex); // brow

    start = "MESSAGESTART--";
    end = "--MESSAGEEND";
    startIndex = message.toString().indexOf(start);
    endIndex = message.toString().indexOf(end, startIndex + start.length);
    mymessage = message.toString().substring(startIndex + start.length, endIndex);
    print("Phone  -- >  " + myphone + " !!!! Message --> " +myphone);

  }

  MessageBuilder mailMessage(String message){
    MessageBuilder builder = MessageBuilder.prepareMultipartAlternativeMessage();
    builder.from = [MailAddress('Ashir Ali', controller.text)];
    builder.to = [MailAddress('Your name', mailsender)];
    builder.subject = 'My first message';
    builder.addTextPlain('hello world.');
    builder.addTextHtml('<p>$message</b></p>');
    return builder;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> sendSMSTONmber(String message,String phone,MailClient mailClient) async {
    final SmsSendStatusListener listener = (SendStatus status) {
      print('SMS Send Status -- > ' + status.name);
      EasyLoading.showToast('SMS Send Status -- > ' + status.name,toastPosition: EasyLoadingToastPosition.bottom);
      String statusmessage = 'SMS Send Status to $phone -- >' + status.name.toString() + ". Message was "+message;
      final builder=mailMessage(statusmessage);
      mailClient.sendMessageBuilder(builder);
    };

    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.sendSms(
          to: phone,
          message: message,
          statusListener: listener
      );
    }

    if (!mounted) return;
  }

  MimeMessage? completeMimeMessage;
  Future<void> mailExample() async {
    String email = controller.text;
    print("lOGIN --> " + controller.text + "  -  > " + pasword.text);
    print('discovering settings for  $email...');
    final config = await Discover.discover(email);
    if (config == null) {
      EasyLoading.showToast('Unable to auto discover settings for $email',toastPosition: EasyLoadingToastPosition.bottom);
      return;
    }
    print('connecting to ${config.displayName}.');
    final account =
    MailAccount.fromDiscoveredSettings('my account', email, pasword.text, config);
    final mailClient = MailClient(account, isLogEnabled: true);
    try {
      await mailClient.connect();
      EasyLoading.showToast('Successfully Logged In',toastPosition: EasyLoadingToastPosition.bottom);
      final mailboxes =
       await mailClient.listMailboxesAsTree(createIntermediate: false);
      //print(mailboxes);
       await mailClient.selectInbox();
      // final messages = await mailClient.fetchMessages(count: 20);
      // for (final msg in messages) {
      //   print(msg);
      // }
      mailClient.eventBus.on<MailLoadEvent>().listen((event) async {
        EasyLoading.showToast('New message at ${DateTime.now()}:',toastPosition: EasyLoadingToastPosition.bottom);
        print("Email  - > >  >" );
        completeMimeMessage = await mailClient.fetchMessageContents(event.message);
        print("Body -->  " + event.toString());
        messageFetch();
        sendSMSTONmber(mymessage,myphone,mailClient);

      });
      await mailClient.startPolling();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  DashboardMain(function: emailUpdate,eamil: mailshow,)),
      );
    } on MailException catch (e) {
      EasyLoading.showToast('High level API failed with $e',toastPosition: EasyLoadingToastPosition.bottom);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 200,
              child: Image.asset(
                  "assets/forward.png"
              ),
            ),
            SizedBox(height: 40,),
            TextFieldWidget(
              name: 'Email',
              hint: 'Enter your Email',
              controller: controller,
              isPassword: false,
              icon: Icons.mail_outline_rounded,
            ),
            SizedBox(height: 10,),
            TextFieldWidget(
              name: 'Password',
              hint: 'Enter your password',
              controller: pasword,
              isPassword: true,
              icon: Icons.password,
            ),
            SizedBox(height: 30,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ButtonWidget(buttonText: 'Login',buttonFunction: () async {
               if(controller!=null && pasword!=null && controller.text!='' && pasword.text!=''){
                 EasyLoading.show(status: 'Please Wait...');
                 await mailExample();
                 EasyLoading.dismiss();
               }else{
                 EasyLoading.showToast('Please Enter Email and Password',toastPosition: EasyLoadingToastPosition.bottom);
               }
              }),
            )
          ],
        ),
      ),
    );
  }
}
