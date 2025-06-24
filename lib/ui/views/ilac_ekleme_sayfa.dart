import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/data/entitiy/ilaclar.dart';
import 'package:ilacim/ui/cubit/ilac_ekleme_sayfa_cubit.dart';

class IlacEklemeSayfa extends StatefulWidget {
  const IlacEklemeSayfa({super.key});

  @override
  State<IlacEklemeSayfa> createState() => _IlacEklemeSayfaState();
}

class _IlacEklemeSayfaState extends State<IlacEklemeSayfa> {
  var ilacIsimController = TextEditingController();
  var toplamMiktarController = TextEditingController();

  String secilenTur = "Tablet";
  String secilenSayi = "1"; // Günlük miktar
  List<String> sayilarListesi = ["1", "2", "3", "4", "5"];
  List<TimeOfDay> secilenSaatler = []; // Seçilen saatler listesi

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    saatPickersGuncelle(int.parse(secilenSayi)); // Varsayılan olarak 1 tane saat picker göster
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height; //707.4285714285714 18:39.3 5: 141.49 16: 44.21 80: 8.84 40: 17.69 50: 14.15 20: 35.37 14: 50.53 8: 88.43 30: 23.58
    return Scaffold(
      appBar: AppBar(
        title: const Text("İlaç Ekle", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        centerTitle: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(ekranYuksekligi/14.15),
          child: BlocProvider(
            create: (context) => IlacEklemeSayfaCubit(),
            child: BlocConsumer<IlacEklemeSayfaCubit, void>(
              listener: (context, state) {},
              builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(height: ekranYuksekligi/23.58,),
                    TextField(
                      controller: ilacIsimController,
                      decoration: const InputDecoration(hintText: "İlaç İsmi"),
                    ),
                    SizedBox(height: ekranYuksekligi/35.37),
                    TextField(
                      controller: toplamMiktarController,
                      decoration: const InputDecoration(hintText: "Toplam Adet ya da İçilecek Kaşık Sayısı"),
                    ),
                    SizedBox(height: ekranYuksekligi/35.37),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Tablet"),
                            value: "Tablet",
                            groupValue: secilenTur,
                            onChanged: (veri) {
                              setState(() {
                                secilenTur = veri!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text("Şurup"),
                            value: "Şurup",
                            groupValue: secilenTur,
                            onChanged: (veri) {
                              setState(() {
                                secilenTur = veri!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ekranYuksekligi/35.37),
                    // Günlük miktar seçimi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Günlük Alınacak Miktar:"),
                        DropdownButton(
                          value: secilenSayi,
                          items: sayilarListesi.map((sayi) {
                            return DropdownMenuItem(value: sayi, child: Text(sayi));
                          }).toList(),
                          onChanged: (veri) {
                            setState(() {
                              secilenSayi = veri!;
                              saatPickersGuncelle(int.parse(secilenSayi)); // Seçime göre picker'ları güncelle
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: ekranYuksekligi/70.74),
                    // Saat picker'larını göster
                    Column(children: saatPickersOlustur()),
                    SizedBox(height: ekranYuksekligi/35.37),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {
                        User? currentUser = auth.currentUser;
                        var ilac = Ilaclar(
                          id: "",
                          email: currentUser!.email.toString(),
                          ilacIsim: ilacIsimController.text.trim(),
                          tur: secilenTur,
                          toplamMiktar: toplamMiktarController.text.trim(),
                          gunlukMiktar: secilenSayi,
                          toplamKullanilan: "0",
                          gunlukKullanilan: "0",
                          zaman: secilenSaatler.map((t) => t.format(context)).join(","), // Saatleri kaydet
                        );
                        context.read<IlacEklemeSayfaCubit>().ilacEkle(ilac);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Kayıt"),
                              content: const Text("İlaç Başarıyla Eklendi"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }, child: const Text("Tamam"),
                                ),
                              ],
                            );
                          },
                        );
                      }, child: const Text("Ekle", style: TextStyle(color: Colors.white),),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Saat picker'larını oluştur
  List<Widget> saatPickersOlustur() {
    List<Widget> saatPickers = [];
    for (int i = 0; i < secilenSaatler.length; i++) {
      saatPickers.add(
        ListTile(
          title: Text(secilenSaatler[i].format(context)),
          trailing: IconButton(
            icon: const Icon(Icons.access_time),
            onPressed: () {
              saatSec(i); // Saat seçme işlemi
            },
          ),
        ),
      );
    }
    return saatPickers;
  }

  // Saat seçme fonksiyonu
  Future<void> saatSec(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: secilenSaatler[index], // Mevcut saati göster
    );
    if (picked != null) {
      setState(() {
        secilenSaatler[index] = picked;
      });
    }
  }

  // Günlük miktara göre saat picker'larını ayarla
  void saatPickersGuncelle(int gunlukMiktar) {
    setState(() {
      secilenSaatler = List.generate(gunlukMiktar, (index) => TimeOfDay.now());
    });
  }
}
