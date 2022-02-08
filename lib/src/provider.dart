
import 'package:emailforwarder/src/pages/utlis/shared_pref.dart';
import 'package:enough_mail/discover/discover.dart';
import 'package:enough_mail/imap/imap_client.dart';
import 'package:enough_mail/imap/imap_events.dart';
import 'package:enough_mail/imap/imap_exception.dart';
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

enum LoadStatus{
  LoadingLogin,
  Loadeded
}

class AuthModel with ChangeNotifier {
  String email = '';
  String password = '';
  bool sendEmailinSENT = true;
  bool sendEmailinFAILURE = true;
  String statuemail = '';
  String phoneStart = 'NUMBERSTART--';
  String phoneEnd = '--NUMBEREND';
  String bodyStart = 'MESSAGESTART--';
  String bodyEnd = '--MESSAGEEND';
  MimeMessage? completeMimeMessage;
  String myphone='';
  String mymessage='';
  final telephony = Telephony.instance;
  bool isLoggedIn=false;
  MailClient? mailClient;
  LoadStatus appStatus=LoadStatus.LoadingLogin;
  bool isSecure=true;
  String imapServer='';
  String imapport='993';
  bool isManual=false;


  SharedPref pref = SharedPref();
  AuthModel() {
    this.initAuth();
  }

  initAuth() async {
    try {
      await getInfo();
    } catch (e) {
      print(['InitAuth Exception:', e.toString()]);
    }
  }

  getInfo() async {
    email = await pref.readObject('user') ?? '';
    isLoggedIn = await pref.readObject('logged') ?? false;
    password = await pref.readObject('password') ?? '';
    imapServer= await pref.readObject('server')??'';
    imapport = await pref.readObject('port')?? '993';
    isManual = await pref.readObject('manual')?? false;
    isSecure= await pref.readObject('issecure')??true;
    sendEmailinSENT = await pref.readObject('sent') ?? true;
    sendEmailinFAILURE = await pref.readObject('failure') ?? true;
    statuemail = await pref.readObject('emailSaved') ?? '';
    phoneStart = await pref.readObject('ps') ?? 'NUMBERSTART--';
    phoneEnd = await pref.readObject('pe') ?? '--NUMBEREND';
    bodyStart = await pref.readObject('bs') ?? 'MESSAGESTART--';
    bodyEnd = await pref.readObject('be') ?? '--MESSAGEEND';
    if(isLoggedIn){
      saveLogin(email,password,isManual);
    }
    appStatus=LoadStatus.Loadeded;
    notifyListeners();
  }

  saveKeywords(String ps, String pe, String bs, String be) {
    phoneStart = ps;
    phoneEnd = pe;
    bodyStart = bs;
    bodyEnd = be;
    pref.saveObject('ps', phoneStart);
    pref.saveObject('pe', phoneEnd);
    pref.saveObject('bs', bodyStart);
    pref.saveObject('be', bodyEnd);
    notifyListeners();
  }

  saveEmailStat(String email, bool sentNotify, bool failNotify) {
    statuemail = email;
    sendEmailinSENT = sentNotify;
    sendEmailinFAILURE = failNotify;
    pref.saveObject('emailSaved', email);
    pref.saveObject('sent', sendEmailinSENT);
    pref.saveObject('failure', sendEmailinFAILURE);
    notifyListeners();
  }

  saveManualConfigurations(String iserver,String ip,bool isSecure ){
     isSecure=isSecure;
     imapServer=iserver;
     imapport=ip;
     pref.saveObject('server', imapServer);
     pref.saveObject('port', ip);
     pref.saveObject('issecure', isSecure);
     notifyListeners();
  }

  Future<bool> saveLogin(String emails, String passwords,bool isMadnual) async {
    bool isLoginSuccess=false;
    isLoginSuccess=await loginIntoMail(emails,passwords,isMadnual);

    if(isLoginSuccess){
      isLoggedIn=true;
      email = emails;
      password = passwords;
      isManual = isMadnual;
      pref.saveObject('user', emails);
      pref.saveObject('password', passwords);
      pref.saveObject('logged', isLoggedIn);
      pref.saveObject('manual', isManual);

    }else{
      isLoggedIn=false;
      email='';
      password='';
    }
    notifyListeners();
    return isLoginSuccess;
  }

  Future<bool> loginIntoMail(String myEmail,String myPassword,bool ISMAN) async {
    EasyLoading.show(status: 'Please Wait...');
    bool status=false;
    print('discovering settings for  $myEmail...');
    var config = await Discover.discover(myEmail);
    var acc;
    if(!ISMAN){
      acc =
          MailAccount.fromDiscoveredSettings('my account', myEmail, myPassword, config!);
    }else{
      acc =
      MailAccount.fromManualSettings('ASHIR', myEmail, imapServer, imapServer, myPassword);
    }

    mailClient= MailClient(acc, isLogEnabled: true);
    try {
      await mailClient?.connect();
      EasyLoading.showToast('Successfully Logged In',toastPosition: EasyLoadingToastPosition.bottom);
      await mailClient?.startPolling();
      await mailClient?.selectInbox();
      mailClient?.eventBus.on<MailLoadEvent>().listen((event) async {
        EasyLoading.showToast('New message at ${DateTime.now()}:',toastPosition: EasyLoadingToastPosition.bottom);
        completeMimeMessage = await mailClient?.fetchMessageContents(event.message);
        fetchMessageNewMail();
        sendSMSTONmber(mymessage,myphone,mailClient!);
      });
      status=true;
      EasyLoading.dismiss();

    } on MailException catch (e) {
      EasyLoading.showToast('High level API failed with $e',toastPosition: EasyLoadingToastPosition.bottom);
      EasyLoading.dismiss();

    } catch(e){
      EasyLoading.dismiss();
      print("Manual Connection");
      EasyLoading.showToast('Error: $e',toastPosition: EasyLoadingToastPosition.bottom);
      //manualHostLogin(imapServer,imapport,isSecure,myEmail,myPassword);
    }
    return status;
  }

  Future<void> sendSMSTONmber(String message,String phone,MailClient mailClient) async {
    final SmsSendStatusListener listener = (SendStatus status) {
      if(sendEmailinSENT && status==SendStatus.SENT){
        final builder=mailMessage(message,status.toString());
        mailClient.sendMessageBuilder(builder);
      }
      if(!sendEmailinSENT && status==SendStatus.SENT){
        print('Please turn on');
      }

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

  fetchMessageNewMail(){
    var message=completeMimeMessage?.parts?[1].decodeTextHtmlPart()?.toString();
    var start = phoneStart;
    var end = phoneEnd;
    var startIndex = message.toString().indexOf(start);
    var endIndex = message.toString().indexOf(end, startIndex + start.length);
    myphone = message.toString().substring(startIndex + start.length, endIndex); // brow
    start = bodyStart;
    end = bodyEnd;
    startIndex = message.toString().indexOf(start);
    endIndex = message.toString().indexOf(end, startIndex + start.length);
    mymessage = message.toString().substring(startIndex + start.length, endIndex);
    print("Phone  -- >  " + myphone + " !!!! Message --> " +myphone);
  }

  MessageBuilder mailMessage(String message,String emailSubject){
    print(emailSubject + "mystatusssss");
    MessageBuilder builder = MessageBuilder.prepareMultipartAlternativeMessage();
    builder.from = [MailAddress('EMAIL2SMS', email)];
    builder.to = [MailAddress('Your name', statuemail)];
    builder.subject = emailSubject.toUpperCase();
    builder.addTextPlain('hello world.');
    builder.addTextHtml('<p>$message</b></p>');
    return builder;
  }

  logOut() async {
    email='';
    password='';
    isLoggedIn=false;
    pref.remove('user');
    pref.remove('password');
    pref.remove('logged');
    notifyListeners();

    try{
      await mailClient?.disconnect();
    } catch(e){
      print(e.toString());
    }

  }

  // Future<void> manualHostLogin(String host,String port,bool isSecure,String username,String password) async {
  //   final client = ImapClient(isLogEnabled: true);
  //   try {
  //     await client.connectToServer(host, int.parse(port),
  //         isSecure: isSecure,);
  //     await client.login(username, password);
  //     final mailboxes = await client.listMailboxes();
  //     print('mailboxes: $mailboxes');
  //     await client.selectInbox();
  //     // fetch 10 most recent messages:
  //     client.eventBus.on<ImapEvent>().listen((event) async {
  //       EasyLoading.showToast('New message at ${DateTime.now()}:',toastPosition: EasyLoadingToastPosition.bottom);
  //     //   completeMimeMessage = await mailClient?.fetchMessageContents(event.eventType.index);
  //       print(event.toString());
  //       // fetchMessageNewMail();
  //       // sendSMSTONmber(mymessage,myphone,mailClient!);
  //     });
  //   } on ImapException catch (e) {
  //     print('IMAP failed with $e');
  //   }
  // }


}
