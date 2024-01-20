import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mpmatik/Services/Log.dart';

class Mail
{
  static const String username = "";

  static final SmtpServer smtpServer = SmtpServer(
    "",
    port: ,
    ssl: true,
    username: username,
    password: "",
    ignoreBadCertificate: true,
  );

  Message setMessage = Message();

  Future<bool> post({required String receiver, required String subject, String? secondReceiver, String? bccReceiver, String? message, String? html, List<XFile?>? images}) async
  {
    setMessage.from = const Address(username,"");
    setMessage.bccRecipients.add("");
    setMessage.recipients.add(receiver);
    if(secondReceiver!=null) {setMessage.recipients.add(secondReceiver);}
    if(bccReceiver!=null) {setMessage.bccRecipients.add(bccReceiver);}
    setMessage.subject = subject;
    if(message!=null) {setMessage.text = message;}
    if(html!=null) {setMessage.html = html;}
    if(images!=null) {for (XFile? i in images) {if(i!=null) {setMessage.attachments.add(FileAttachment(File(i.path)));}}}
    try
    {
      final String response = (await send(setMessage,smtpServer)).toString();
      if(response.contains("Message successfully sent."))
      {
        return true;
      }
      return false;
    }
    on MailerException catch(e,s)
    {
      Log.save(e,s);
      return false;
    }
  }
}