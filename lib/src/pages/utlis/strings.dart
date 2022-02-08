import 'package:flutter/material.dart';

List<String> helping_strings = [
  'Usage on phones with only 1 SIM card:',
  'If your phone has only 1 SIM card then you shouldn\'t need to change any settings. Simply allow the app to send SMS messages when you are asked to authorize the app to do so.',
  'Usage on Dual-SIM phones:',
  'If you have a Dual-SIM phone then the app can only use the default SIM for SMS message sending. The Android system doesn\'t allow the app to change the SIM card before sending an SMS message so it is not possible to set the SIM card to use in our app.',
  'Open your phone settings and select the SIM card settings. \nHopefully, you can find an option where you can select the default SIM for SMS.\nIf you can\'t find any Dual-SIM settings then check if they are hidden. Find an option "Show advanced settings" or similar and activate it.',
  '''If there is no default SIM for SMS setting:
De-activate the SIM card you DON'T want to use for this app or take out the SIM card temporarily if there is no such option.
Then open the SMS app and send an SMS.
Re-activate (or re-insert) the other SIM card.
The default SIM card should now be set to the SIM card that was still active when the SMS has been sent.''',
  'Required settings',
  'After starting the app you must set the email address and password of the gateway email account you want to use as your email to SMS gateway inbox for the app. We recommend creating a dedicated free account that is used by this app only - e.g. a new GMAIL account. However, you can use any email account you want including your existing regular email account.',
  'If you want to receive status emails indicating whether the SMS has been sent successfully or not you need to provide a status email address to which the status messages are being sent.',
  'Usage',
  'To send an SMS using the email to SMS gateway simply send an email to the address you have configured as the gateway account as described above.',
  'The email must contain the phone number and the text to be sent as an SMS message anywhere in the email body using the following format:',
  '''NUMBERSTART--+11123456789--NUMBEREND
MESSAGESTART--This is my first SMS messaged--MESSAGEEND''',
  'So the phone number must be enclosed by the keywords "NUMBERSTART--" and "--NUMBEREND", the SMS message body text by the keywords "MESSAGESTART--" and "--MESSAGEEND".',
  'The phone number and the message body can appear at the beginning or end or anywhere else in the email body.',
  'Whenever an email containing these keywords is received by the gateway email account the app will automatically pull the email from the gateway account, extract the phone number and the SMS message text, and will then try to send the SMS.',
  'If an email address to receive status emails has been configured then a status email will be sent to the status email address. The status email that is sent by the app is the same as the original email received by the gateway account earlier except that the email subject is preceded by one of the words "FAILED", "SENT" or "DELIVERED" and if the SMS was not delivered then the email body is preceded by the detailed error message explaining why the SMS has not been delivered.',
  'That\'s it. We hope that you will enjoy the app and save lots of money with your SMS campaigns moving forward.'

];
