import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ilacim/bildirim/notification_preferences.dart';
import 'package:ilacim/bildirim/notification_service.dart';
import 'package:ilacim/bildirim/plan_notification.dart';
import 'package:ilacim/ui/cubit/hesabim_cubit.dart';

class Hesabim extends StatefulWidget {
  const Hesabim({super.key});

  @override
  State<Hesabim> createState() => _HesabimState();
}

class _HesabimState extends State<Hesabim> {
  var tfEmail = TextEditingController();
  var tfAd = TextEditingController();
  var tfSoyad = TextEditingController();
  var tfDTarih = TextEditingController();

  bool bildirimIzni = false;

  @override
  void initState() {
    super.initState();
    context.read<HesabimCubit>().kullaniciBilgileriniYukle();

    // SharedPreferences üzerinden bildirim izni durumunu yükle
    NotificationPreferences.isEnabled().then((value) {
      setState(() {
        bildirimIzni = value;
      });
    });
  }

  void _toggleSwitch(bool value) async {
    setState(() {
      bildirimIzni = value;
    });

    await NotificationPreferences.setEnabled(value);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (value) {
        await planNotificationsForUser(user.uid);
      } else {
        await NotificationService.cancelAll();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hesabım", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: BlocBuilder<HesabimCubit, Map<String, dynamic>?>(
        builder: (context, userData) {
          if (userData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          tfEmail.text = userData["email"];
          tfAd.text = userData["ad"];
          tfSoyad.text = userData["soyad"];
          tfDTarih.text = userData["dtarih"];

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  right: ekranGenisligi / 8.23,
                  left: ekranGenisligi / 8.23,
                  top: ekranYuksekligi / 14.15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bilgilerim",
                      style: TextStyle(fontSize: ekranYuksekligi / 17.69),
                    ),
                    SizedBox(height: ekranYuksekligi / 17.69),

                    // TEXTFIELDS
                    textField(tfAd, ekranGenisligi, "Adınızı Giriniz"),
                    textField(tfSoyad, ekranGenisligi, "Soyadınızı Giriniz"),
                    textField(tfDTarih, ekranGenisligi, "Doğum Tarihinizi Giriniz (GG.AA.YYYY)"),
                    textField(tfEmail, ekranGenisligi, "Email", enabled: false),

                    SizedBox(height: ekranYuksekligi / 40),

                    // BİLDİRİM SWITCH
                    SwitchListTile(
                      title: const Text("Bildirimlere izin ver"),
                      value: bildirimIzni,
                      onChanged: _toggleSwitch,
                    ),

                    SizedBox(height: ekranYuksekligi / 20),

                    // GÜNCELLE BUTONU
                    SizedBox(
                      width: double.infinity,
                      height: ekranYuksekligi / 14.15,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          context.read<HesabimCubit>().kullaniciBilgileriniGuncelle(
                            ad: tfAd.text,
                            soyad: tfSoyad.text,
                            dtarih: tfDTarih.text,
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Bilgilerimi Güncelle"),
                                content: const Text("Bilgileriniz Başarıyla Güncellendi."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Tamam"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          "Güncelle",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ekranYuksekligi / 35.37,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget textField(TextEditingController controller, double ekranGenisligi, String hint,
      {bool isPassword = false, bool enabled = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: ekranGenisligi / 25.71),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        enabled: enabled,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}
