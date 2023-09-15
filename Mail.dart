import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
//  mailer: ^6.0.0

class Mail
{
  String kullaniciAdi;
  String sifre;

  Mail(this.kullaniciAdi,this.sifre);

  SmtpServer? smtpServer;

  Message message = Message();

  Future<void> kurumsalServer({required String adres,required int port,required bool ssl, bool? ignoreBadCertificate}) async
  {
    smtpServer = SmtpServer(adres,
      port: port,
      ssl: ssl,
      username: kullaniciAdi,
      password: sifre,
      ignoreBadCertificate: ignoreBadCertificate ?? false,
    );
  }

  Future<void> gmailServer() async => smtpServer = gmail(kullaniciAdi, sifre);

  Future<List<String>> cokluGonder({required List<String> alicilar, String? konu, String? mesaj, String? html, String? gorunenAd}) async
  {
    List<String> response = [];
    for(int x = 0 ; x < alicilar.length ; x++)
    {
      response.add(await gonder(alici: alicilar[x], konu: konu, mesaj: mesaj, html: html, gorunenAd: gorunenAd));
    }
    return response;
  }

  Future<String> gonder({required String alici, String? konu, String? mesaj, String? html, String? gorunenAd}) async
  {
    smtpServer ?? await gmailServer();
    message = Message()
      ..from = Address(kullaniciAdi, gorunenAd ?? kullaniciAdi)
      ..recipients.add(alici);

    if(konu != null)
    {
      message.subject = konu;
    }
    if(mesaj != null)
    {
      message.text = mesaj;
    }
    if(html != null)
    {
      message.html = html;
    }
    try
    {
      final response = await send(message, smtpServer!);
      return response.toString();
    }
    on MailerException catch(e)
    {
      throw Exception("Mail gönderilirken hata oluştu: $e");
    }
  }
}