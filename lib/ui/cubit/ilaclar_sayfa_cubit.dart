import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/data/entitiy/ilaclar.dart';
import 'package:ilacim/data/entitiy/repo/ilaclardao_repository.dart';

class IlaclarSayfaCubit extends Cubit<List<Ilaclar>> {
  IlaclarSayfaCubit():super(<Ilaclar>[]);

  var irepo = IlaclarDaoRepository();
  var collectionIlaclar = FirebaseFirestore.instance.collection("ilaclar");

  Future<void> ilaclariYukle() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    collectionIlaclar.where("email", isEqualTo: email).snapshots().listen((event) {
      var ilaclarListesi = <Ilaclar>[];
      var documents = event.docs;
      for (var document in documents) {
        var key = document.id;
        var data = document.data();
        var ilac = Ilaclar.fromJson(data, key);
        ilaclarListesi.add(ilac);
      }
      emit(ilaclarListesi);
    });
  }

  void ilacKullaniminiGuncelle(String ilacId) async {
    await irepo.ilacKullaniminiGuncelle(ilacId);
  }

}