import 'package:emailforwarder/src/pages/auth/login.dart';
import 'package:emailforwarder/src/pages/dashboard.dart';
import 'package:emailforwarder/src/pages/utlis/shared_pref.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:telephony/telephony.dart';
MimeMessage? completeMimeMessage;
final telephony = Telephony.instance;
String myphone='';
String mymessage='';
String mailsender='muhammadashirali4@gmail.com';
String mailshow='';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPref pref=SharedPref();

  String? username=await pref.readObject('user')??'';
  String? password=await pref.readObject('password');
  String? email =await pref.readObject('emailSaved')??'';
  print("username -- >"+username.toString());
  bool isloggedin=false;
  if(username.toString()!=''){
    isloggedin= await mailExample(
      username.toString(),password.toString(),email.toString()
    );
    print("this isss "+isloggedin.toString());
    runApp(MyApp(email: email.toString(),isLogggedIn: isloggedin,));
  }else{
    print("this -->");
    runApp(MyApp(email: email.toString(),isLogggedIn: isloggedin,));
  }
}



class MyApp extends StatelessWidget {
  final bool isLogggedIn;
  final String email;
   MyApp({Key? key,this.isLogggedIn=false,this.email=''}) : super(key: key);

  SharedPref pref=SharedPref();
  void emailUpdate(String mail){
    pref.saveObject('emailSaved', mail);
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EmailToSMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: isLogggedIn ? DashboardMain(function: emailUpdate,eamil: email,)  : LoginScreen(),
      builder: EasyLoading.init(),
    );
  }
}



Future<bool> mailExample(String emailtemp,String password,String email) async {
  bool result=false;
  String email = emailtemp;
  print('discovering settings for  $email...');
  final config = await Discover.discover(email);
  if (config == null) {
    return result;
  }
  print('connecting to ${config.displayName}.');
  final account =
  MailAccount.fromDiscoveredSettings('my account', email, password, config);
  final mailClient = MailClient(account, isLogEnabled: true);
  try {
    await mailClient.connect();
    final mailboxes =
    await mailClient.listMailboxesAsTree(createIntermediate: false);
    //print(mailboxes);
    await mailClient.selectInbox();
    // final messages = await mailClient.fetchMessages(count: 20);
    // for (final msg in messages) {
    //   print(msg);
    // }
    mailClient.eventBus.on<MailLoadEvent>().listen((event) async {
      print("Email  - > >  >" );
      completeMimeMessage = await mailClient.fetchMessageContents(event.message);
      print("Body -->  " + event.toString());
      messageFetch();
      sendSMSTONmber(mymessage,myphone,mailClient,emailtemp);
    });
    await mailClient.startPolling();
     result=true;
  } on MailException catch (e) {
  }
  return result;
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



MessageBuilder mailMessage(String message,String emailtemp){
  MessageBuilder builder = MessageBuilder.prepareMultipartAlternativeMessage();
  builder.from = [MailAddress('Ashir Ali', emailtemp)];
  builder.to = [MailAddress('Your name', mailsender)];
  builder.subject = 'My first message';
  builder.addTextPlain('hello world.');
  builder.addTextHtml('<p>$message</b></p>');
  return builder;
}


Future<void> sendSMSTONmber(String message,String phone,MailClient mailClient,String mymail) async {
  final SmsSendStatusListener listener = (SendStatus status) {
    print('SMS Send Status -- > ' + status.name);
    String statusmessage = 'SMS Send Status to $phone -- >' + status.name.toString() + ". Message was "+message;
    final builder=mailMessage(statusmessage,mymail);
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

}



