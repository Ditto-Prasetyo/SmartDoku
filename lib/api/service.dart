import 'package:url_launcher/url_launcher.dart';

class WhatsappService { 
  Future<bool> launchWhatsApp() async {
    final adminNumber = "6285161015745";
    final message =
        "Selamat pagi Admin, saya lupa password akun saya. Mohon bantuannya. Terima kasih.";
    final url =
        "https://wa.me/$adminNumber?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return true;
    } else {
      return false;
    }
  }
}