import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/data/entitiy/ilaclar.dart';
import 'package:ilacim/ui/cubit/anasayfa_cubit.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  List<Map<String, String>> gunler = gunleriHesapla();

  @override
  void initState() {
    super.initState();
    context.read<AnasayfaCubit>().ilaclariYukle();
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height; //707.4285714285714 18:39.3 5: 141.49 16: 44.21 80: 8.84 40: 17.69 50: 14.15 20: 35.37 14: 50.53 8: 88.43 30: 23.58
    final double ekranGenisligi = ekranBilgisi.size.width; //411.42857142857144 50: 8.23 20: 20.57 16: 25.71

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ekranYuksekligi/44.21), //16
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: gunler.map((gun) {
                bool isToday = gun["bugun"] == "true";
                return Column(
                  children: [
                    Container(
                      width: ekranGenisligi/8.23, //50
                      padding: EdgeInsets.all(ekranYuksekligi/70.74), //10
                      decoration: BoxDecoration(
                        color: isToday ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        children: [
                          Text(
                            gun["gun"]!,
                            style: TextStyle(
                              fontSize: ekranYuksekligi/54.42, //13
                              fontWeight: FontWeight.bold,
                              color: isToday ? Colors.white54 : Colors.black38,
                            ),
                          ),
                          Text(
                            gun["tarih"]!,
                            style: TextStyle(
                              fontSize: ekranYuksekligi/44.21, //16
                              fontWeight: FontWeight.bold,
                              color: isToday ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: ekranYuksekligi/35.37,), //20
            Text("Günlük Takip", style: TextStyle(fontSize: ekranYuksekligi/23.58, fontWeight: FontWeight.bold),), //30
            SizedBox(height: ekranYuksekligi/70.74,),
            Text("İlaç Kullanımı:", style: TextStyle(fontSize: ekranYuksekligi/39.3, color: Colors.black38),), //18
            // BlocBuilder ile ilaçları yüklerken, loading state ve listelere erişim durumu
            BlocBuilder<AnasayfaCubit, List<Ilaclar>>(
              builder: (context, ilaclarListesi) {
                if (ilaclarListesi.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: ekranYuksekligi/14.15), //50
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("İlacınız Bulunmamaktadır", style: TextStyle(fontSize: ekranYuksekligi/39.3, color: Colors.black38),), //18
                        ],
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: ilaclarListesi.length,
                      itemBuilder: (context, indeks) {
                        var ilac = ilaclarListesi[indeks];
                        return Card(
                          child: SizedBox(
                            child: Padding(
                              padding: EdgeInsets.all(ekranYuksekligi/44.21), //16
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(ilac.ilacIsim, style: TextStyle(fontSize: ekranYuksekligi/35.37, fontWeight: FontWeight.bold)),
                                          Text(ilac.tur),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(20), // Kenarları yuvarlamak için
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(right: ekranGenisligi/25.71, left: ekranGenisligi/25.71), //16
                                          child: Text(
                                              "${ilac.gunlukKullanilan}/${ilac.gunlukMiktar}",
                                              style: TextStyle(color: Colors.white, fontSize: ekranGenisligi/20.57),), //20
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ekranYuksekligi/35.37,), //20
                                  Column(children: zamanlariGoster(ilac.zaman, ekranYuksekligi, ilac.id, context),),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, String>> gunleriHesapla() {
  DateTime today = DateTime.now();
  List<Map<String, String>> gunler = [];

  List<String> gunIsimleri = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"];

  for (int i = -3; i <= 3; i++) {
    DateTime date = today.add(Duration(days: i));
    int day = date.day;
    int weekday = date.weekday; // 1 = Monday, 2 = Tuesday, ...

    String formattedDate = "$day"; // sadece gün

    gunler.add({
      "gun": gunIsimleri[weekday - 1], // Gün ismi
      "tarih": formattedDate, // Tarih sadece gün
      "bugun": (i == 0).toString(), // Bugün mü?
    });
  }

  return gunler;
}

List<Widget> zamanlariGoster(String zamanlar, double ekranYuksekligi, String ilacId, BuildContext context) {
  // Zamanları virgülle ayırıyoruz
  List<String> zamanListesi = zamanlar.split(",");

  // Her bir zamanı gösteren container'ları döndüren bir liste oluşturuyoruz
  return zamanListesi.map((zaman) {
    return GestureDetector(
      onTap: (){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("İlacım"),
              content: const Text("İlacını aldın mı?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, child: const Text("Hayır", style: TextStyle(color: Colors.red),),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AnasayfaCubit>().ilacKullaniminiGuncelle(ilacId);
                    Navigator.pop(context);
                  }, child: const Text("Evet", style: TextStyle(color: Colors.green),),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: ekranYuksekligi/14.15,
        margin: EdgeInsets.symmetric(vertical: ekranYuksekligi/141.49), // 5 Her bir container arasına boşluk koymak için
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(10), // Kenarları yuvarlamak için
        ),
        child: Padding(
          padding: EdgeInsets.all(ekranYuksekligi/88.43), //8
          child: Row(
            children: [
              const Icon(Icons.notifications_none),
              const Spacer(),
              const Text("Miktar: 1"),
              const Spacer(),
              const Icon(Icons.access_time),
              Text(" $zaman", style: TextStyle(fontSize: ekranYuksekligi/44.21)), //16

            ],
          ),
        ),
      ),
    );
  }).toList();
}