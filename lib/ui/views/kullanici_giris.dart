import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/ui/cubit/kullanici_giris_cubit.dart';
import 'package:ilacim/ui/views/sabit_yapilar.dart';
import 'package:ilacim/ui/views/kullanici_kayit.dart';

class KullaniciGiris extends StatefulWidget {
  const KullaniciGiris({super.key});

  @override
  State<KullaniciGiris> createState() => _KullaniciGirisState();
}

class _KullaniciGirisState extends State<KullaniciGiris> {
  var tfEmail = TextEditingController();
  var tfSifre = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(backgroundColor: Colors.green),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Bu metot ile kontrol sağlıyor
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Kullanıcı giriş yapmışsa direkt yönlendirme
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationSayfa()),);
            });
            return const SizedBox();
          } else { //kullanıcı giriş yapmamışsa;
            return BlocConsumer<KullaniciGirisCubit, KullaniciGirisState>(
              listener: (context, state) {
                if (state is KullaniciGirisSuccess) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationSayfa()),);
                } else if (state is KullaniciGirisFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)),);
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: ekranGenisligi / 8.23, left: ekranGenisligi / 8.23, top: ekranYuksekligi / 8.84,),
                      child: Column(
                        children: [
                          Text("İlacım", style: TextStyle(fontSize: ekranYuksekligi / 17.69, fontWeight: FontWeight.bold, color: Colors.white,),),
                          SizedBox(height: ekranYuksekligi / 17.69),
                          TextField(controller: tfEmail, style: const TextStyle(color: Colors.white), cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              hintText: "Email Adresinizi Giriniz",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: ekranYuksekligi / 17.69), //40
                          TextField(controller: tfSifre, style: const TextStyle(color: Colors.white), obscureText: true, cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              hintText: "Parola Giriniz",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: ekranYuksekligi / 17.69), //40
                          SizedBox(
                            width: double.infinity,
                            height: ekranYuksekligi / 14.15, //50
                            child: ElevatedButton(
                              onPressed: () {
                                String email = tfEmail.text.trim();
                                String password = tfSifre.text.trim();
                                context.read<KullaniciGirisCubit>().girisYap(email, password);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ), child: state is KullaniciGirisLoading
                                ? const CircularProgressIndicator(color: Colors.white) //Eğer yükleniyorsa progressbar koyduk
                                : Text("Giriş", style: TextStyle(fontSize: ekranYuksekligi / 35.37),),),
                          ),
                          SizedBox(height: ekranYuksekligi / 70.74),
                          SizedBox(
                            width: double.infinity,
                            height: ekranYuksekligi / 14.15,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KullaniciKayit()),);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ), child: Text("Kayıt Ol", style: TextStyle(fontSize: ekranYuksekligi / 35.37, color: Colors.white),),),
                          ),
                          SizedBox(height: ekranYuksekligi / 17.69),
                          TextButton(
                            onPressed: () {},
                            child: Text("Şifremi Unuttum", style: TextStyle(color: Colors.white60, fontSize: ekranYuksekligi / 50.53),),),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
