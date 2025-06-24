import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/data/entitiy/ilaclar.dart';
import 'package:ilacim/ui/cubit/ilaclar_sayfa_cubit.dart';
import 'package:ilacim/ui/views/ilac_ekleme_sayfa.dart';

class IlaclarSayfa extends StatefulWidget {
  const IlaclarSayfa({super.key});

  @override
  State<IlaclarSayfa> createState() => _IlaclarSayfaState();
}

class _IlaclarSayfaState extends State<IlaclarSayfa> {

  @override
  void initState() {
    super.initState();
    context.read<IlaclarSayfaCubit>().ilaclariYukle();
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height; //707.4285714285714 18:39.3 5: 141.49 16: 44.21 80: 8.84 40: 17.69 50: 14.15 20: 35.37 14: 50.53 8: 88.43 30: 23.58
    final double ekranGenisligi = ekranBilgisi.size.width; //411.42857142857144 50: 8.23 20: 20.57 16: 25.71

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ekranYuksekligi/44.21),
        child: Column(
          children: [
            Row(
              children: [
                Text("İlaçlarım:", style: TextStyle(fontSize: ekranYuksekligi/39.3, color: Colors.black38),), //18
                const Spacer(),
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const IlacEklemeSayfa()));
                }, icon: const Icon(Icons.add, color: Colors.green,)),
              ],
            ),
            const Divider(color: Colors.black38, thickness: 1,),
            BlocBuilder<IlaclarSayfaCubit, List<Ilaclar>>(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(ilac.ilacIsim, style: TextStyle(fontSize: ekranYuksekligi/23.58, fontWeight: FontWeight.bold)), //30
                                          Text(ilac.tur, style: TextStyle(fontSize: ekranYuksekligi/44.21)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ekranYuksekligi/70.74,), //10
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(10), // Kenarları yuvarlamak için
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(ekranYuksekligi/88.43), //8
                                      child: Row(
                                        children: [
                                          Text("Bugün Kullanılan:", style: TextStyle(fontSize: ekranGenisligi/25.71),), //20
                                          const Spacer(),
                                          Text(ilac.gunlukKullanilan, style: TextStyle(fontSize: ekranYuksekligi/35.37),),
                                        ],
                                      ), //20
                                    ),
                                  ),
                                  SizedBox(height: ekranYuksekligi/70.74,), //10
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(10), // Kenarları yuvarlamak için
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(ekranYuksekligi/88.43), //8
                                      child: Row(
                                        children: [
                                          Text("Toplam Kullanım:", style: TextStyle(fontSize: ekranGenisligi/25.71),), //20
                                          const Spacer(),
                                          Text("${ilac.toplamKullanilan}/${ilac.toplamMiktar}", style: TextStyle(fontSize: ekranYuksekligi/35.37),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: ekranYuksekligi/35.37,), //20
                                  const Text("Hatırlatıcılar"),
                                  SizedBox(height: ekranYuksekligi/70.74,), //10
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(children: zamanlariGoster(ilac.zaman, ekranYuksekligi, ekranGenisligi, ilac.id, context),)
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
              },
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> zamanlariGoster(String zamanlar, double ekranYuksekligi, double ekranGenisligi, String ilacId, BuildContext context) {
  // Zamanları virgülle ayırıyoruz
  List<String> zamanListesi = zamanlar.split(",");

  // Her bir zamanı gösteren container'ları döndüren bir liste oluşturuyoruz
  return zamanListesi.map((zaman) {
    return Container(
      height: ekranYuksekligi/14.15,
      margin: EdgeInsets.symmetric(horizontal: ekranGenisligi/82.29), // 5 Her bir container arasına boşluk koymak için
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10), // Kenarları yuvarlamak için
      ),
      child: Padding(
        padding: EdgeInsets.all(ekranYuksekligi/88.43), //8
        child: Row(
          children: [
            const Icon(Icons.access_time),
            Text(" $zaman", style: TextStyle(fontSize: ekranYuksekligi/44.21)), //16
          ],
        ),
      ),
    );
  }).toList();
}
