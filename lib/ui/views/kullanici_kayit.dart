import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/ui/cubit/kullanici_kayit_cubit.dart';
import 'package:ilacim/ui/views/sabit_yapilar.dart';
import 'package:ilacim/ui/views/kullanici_giris.dart';

class KullaniciKayit extends StatefulWidget {
  const KullaniciKayit({super.key});

  @override
  State<KullaniciKayit> createState() => _KullaniciKayitState();
}

class _KullaniciKayitState extends State<KullaniciKayit> {
  var tfEmail = TextEditingController();
  var tfSifre = TextEditingController();
  var tfAd = TextEditingController();
  var tfSoyad = TextEditingController();
  var tfDTarih = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text("İlacım", style: TextStyle(color: Colors.white)),
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KullaniciGiris()),);
        }, icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white,)),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: BlocConsumer<KullaniciKayitCubit, KullaniciKayitState>(
        listener: (context, state) {
          if (state is KullaniciKayitSuccess) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationSayfa()),);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Kayıt İşlemi Gerçekleştirildi")));
          } else if (state is KullaniciKayitFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
            ));
          }
        },
        builder: (context, state) {
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
                    Text("Kayıt Ol",
                        style: TextStyle(
                            fontSize: ekranYuksekligi / 17.69,
                            color: Colors.white)),
                    SizedBox(height: ekranYuksekligi / 17.69),

                    // TextFields
                    textField(tfAd, ekranGenisligi, "Adınızı Giriniz"),
                    textField(tfSoyad, ekranGenisligi, "Soyadınızı Giriniz"),
                    textField(tfDTarih, ekranGenisligi, "Doğum Tarihinizi Giriniz (GG.AA.YYYY)"),
                    textField(tfEmail, ekranGenisligi, "Email Adresinizi Giriniz"),
                    textField(tfSifre, ekranGenisligi, "Parola Giriniz", isPassword: true),

                    SizedBox(height: ekranYuksekligi / 17.69),

                    // Kayıt Button
                    SizedBox(
                      width: double.infinity,
                      height: ekranYuksekligi / 14.15,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<KullaniciKayitCubit>().kayitOl(
                            tfEmail.text.trim(),
                            tfSifre.text.trim(),
                            tfAd.text.trim(),
                            tfSoyad.text.trim(),
                            tfDTarih.text.trim(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Text("Kayıt", style: TextStyle(fontSize: ekranYuksekligi / 35.37)),
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

  // TextField Widget
  Widget textField(TextEditingController controller, double ekranGenisligi, String hint, {bool isPassword = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: ekranGenisligi / 25.71), //16
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        obscureText: isPassword,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
        ),
      ),
    );
  }
}
