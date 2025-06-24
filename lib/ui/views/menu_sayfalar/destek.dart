import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/ui/cubit/destek_cubit.dart';

class Destek extends StatefulWidget {
  const Destek({super.key});

  @override
  State<Destek> createState() => _DestekState();
}

class _DestekState extends State<Destek> {
  var tfController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height; //707.4285714285714 18:39.3 5: 141.49 16: 44.21 80: 8.84 40: 17.69 50: 14.15 20: 35.37 14: 50.53 8: 88.43 30: 23.58
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bize Destek Olun", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        centerTitle: true,),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(ekranYuksekligi/35.37), //20
            child: Column(
              children: [
                SizedBox(height: ekranYuksekligi/23.58,), //30
                SelectableText(
                    "Bir şikayetiniz varsa ya da uygulamanın gelişmesine yardımcı olmak isterseniz yorum yazarak bize destek olabilirsiniz.",
                    style: TextStyle(fontSize: ekranYuksekligi/39.3),), //18
                SizedBox(height: ekranYuksekligi/23.58,), //30
                TextField(
                  controller: tfController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Yorum yazınız.",
                    border: OutlineInputBorder(),),
                ),
                SizedBox(height: ekranYuksekligi/23.58,), //30
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    if(tfController.text != ""){
                      var currentUser = FirebaseAuth.instance.currentUser;
                      context.read<DestekCubit>().yorumEkle(currentUser!.email.toString(), tfController.text.trim(), DateTime.now().toIso8601String());
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Destek"),
                            content: const Text("Yorumunuz Başarıyla Gönderildi."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  tfController.text = "";
                                }, child: const Text("Tamam"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }, child: const Text("Gönder", style: TextStyle(color: Colors.white),),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
