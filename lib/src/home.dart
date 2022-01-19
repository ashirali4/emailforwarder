import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:telephony/telephony.dart';
import 'dart:io';
import 'package:enough_mail/enough_mail.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final telephony = Telephony.instance;





  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final SmsSendStatusListener listener = (SendStatus status) {
      print("This is Status " + status.name);
    };

    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.sendSms(
          to: "03447118269",
          message: "May the force be with you!",
          statusListener: listener
      );
    }

    if (!mounted) return;
  }












  String userName = 'ashir@mtz.bcm.mybluehost.me';
  String password = 'ALIali123';
  String imapServerHost = 'mail.mtz.bcm.mybluehost.me';
  int imapServerPort = 993;
  bool isImapServerSecure = true;


















  Future<void> imapExample() async {
    final client = ImapClient(isLogEnabled: false);
    try {
      await client.connectToServer(imapServerHost, imapServerPort,
          isSecure: isImapServerSecure);
      await client.login(userName, password);
      final mailboxes = await client.listMailboxes();

      print('mailboxes: $mailboxes');
      await client.selectInbox();
      // fetch 10 most recent messages:
      final fetchResult = await client.fetchRecentMessages(
          messageCount: 10, criteria: 'BODY.PEEK[]');
      for (final message in fetchResult.messages) {
        print(message);
      }
      client.eventBus.on<MailLoadEvent>().listen((event) {
        print('New message at ${DateTime.now()}:');
        print(event.message);
      });
      await client.logout();
    } on ImapException catch (e) {
      print('IMAP failed with ' + e.toString());
    }
  }







  @override
  void initState() {
    imapExample();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ASHIR'),
      ),
      body: InkWell(
        onTap: (){
          imapExample();
        },
        child: Center(
          child: Container(
            child: Text("Hit Me"),
          ),
        ),
      ),
    );
  }


}
