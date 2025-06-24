import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ilacim/ui/views/bottom_navigation_sayfalar/anasayfa.dart';
import 'package:ilacim/ui/views/bottom_navigation_sayfalar/ilaclar_sayfa.dart';
import 'package:ilacim/ui/views/bottom_navigation_sayfalar/istatistik_sayfa.dart';
import 'package:ilacim/ui/views/kullanici_giris.dart';
import 'package:ilacim/ui/views/menu_sayfalar/destek.dart';
import 'package:ilacim/ui/views/menu_sayfalar/hesabim.dart';

class BottomNavigationSayfa extends StatefulWidget {
  const BottomNavigationSayfa({super.key});

  @override
  State<BottomNavigationSayfa> createState() => _BottomNavigationSayfaState();
}

class _BottomNavigationSayfaState extends State<BottomNavigationSayfa> {
  int secilenIndex = 0;
  var sayfalar = [const Anasayfa(),const IlaclarSayfa(), const IstatistikSayfa()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("İlacım", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // Menü butonu siyah olur
      ),
      // Ekranı kaplayan menü (Drawer)
      drawer: Drawer(
        child: Container(
          color: Colors.green, // Menü arka plan rengi
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Menü Başlık
              const Text(
                "Menü",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Menü Öğeleri
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text('Ana Sayfa', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Ana sayfaya gitme işlemi
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationSayfa()),);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('Hesabım', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Ayarlara gitme işlemi
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Hesabim()),);
                },
              ),
              ListTile(
                leading: const Icon(Icons.comment, color: Colors.white),
                title: const Text('Bize Destek Olun', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Ayarlara gitme işlemi
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Destek()),);
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.white),
                title: const Text('Çıkış', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Firebase'den çıkış yap
                  FirebaseAuth.instance.signOut().then((_) {
                    // Çıkış yaptıktan sonra KullaniciGiris sayfasına yönlendir
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KullaniciGiris()),);
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: sayfalar[secilenIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "",),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: "",),
          BottomNavigationBarItem(icon: Icon(Icons.stacked_bar_chart), label: "",),
        ],
        currentIndex: secilenIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,

        onTap: (indeks){
          setState(() {
            secilenIndex = indeks;
          });
        },
      ),
    );
  }
}
