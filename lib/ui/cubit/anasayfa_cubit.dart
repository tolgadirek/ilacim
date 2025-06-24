import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/bildirim/notification_service.dart';
import 'package:ilacim/data/entitiy/ilaclar.dart';
import 'package:ilacim/data/entitiy/repo/ilaclardao_repository.dart';

class AnasayfaCubit extends Cubit<List<Ilaclar>> {
  AnasayfaCubit() : super(<Ilaclar>[]);

  var irepo = IlaclarDaoRepository();
  var collectionIlaclar = FirebaseFirestore.instance.collection("ilaclar");

  Future<void> ilaclariYukle() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    collectionIlaclar.where("email", isEqualTo: email).snapshots().listen((event) async {
      var ilaclarListesi = <Ilaclar>[];
      for (var document in event.docs) {
        var key = document.id;
        var data = document.data();
        int toplamKullanilan = int.parse(data["toplamKullanilan"]);
        int toplamMiktar = int.parse(data["toplamMiktar"]);

        if (toplamKullanilan < toplamMiktar) {
          var ilac = Ilaclar.fromJson(data, key);
          ilaclarListesi.add(ilac);
        } else {
          await NotificationService.cancelByIlacId(key);
        }
      }
      emit(ilaclarListesi);
    });
  }

  void ilacKullaniminiGuncelle(String ilacId) async {
    await irepo.ilacKullaniminiGuncelle(ilacId);
  }
}
