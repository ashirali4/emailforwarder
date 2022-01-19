import 'package:enough_mail/discover/discover.dart';
import 'package:enough_mail/mail/mail_account.dart';
import 'package:enough_mail/mail/mail_client.dart';
import 'package:enough_mail/mail/mail_events.dart';
import 'package:enough_mail/mail/mail_exception.dart';
import 'package:flutter/material.dart';
class TEest extends StatefulWidget {
  const TEest({Key? key}) : super(key: key);

  @override
  _TEestState createState() => _TEestState();
}

class _TEestState extends State<TEest> {

  String userName = 'ashir@mtz.bcm.mybluehost.me';
  String password = 'ALIali123';

  Future<void> mailExample() async {
    final email = '$userName';
    print('discovering settings for  $email...');
    final config = await Discover.discover(email);
    if (config == null) {
      // note that you can also directly create an account when
      // you cannot autodiscover the settings:
      // Compare [MailAccount.fromManualSettings] and [MailAccount.fromManualSettingsWithAuth]
      // methods for details
      print('Unable to autodiscover settings for $email');
      return;
    }
    print('connecting to ${config.displayName}.');
    final account =
    MailAccount.fromDiscoveredSettings('my account', email, password, config);
    final mailClient = MailClient(account, isLogEnabled: true);
    try {
      await mailClient.connect();
      print('connected');
      final mailboxes =
      await mailClient.listMailboxesAsTree(createIntermediate: false);
      print(mailboxes);
      await mailClient.selectInbox();
      final messages = await mailClient.fetchMessages(count: 20);
      for (final msg in messages) {
        print(msg);
      }
      mailClient.eventBus.on<MailLoadEvent>().listen((event) {
        print('New message at ${DateTime.now()}:');
        print(event.message);
      });
      await mailClient.startPolling();
    } on MailException catch (e) {
      print('High level API failed with $e');
    }
  }


  @override
  void initState() {
    mailExample();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mail Box'),
      ),
    );
  }
}
