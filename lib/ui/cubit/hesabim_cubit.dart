import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HesabimCubit extends Cubit<Map<String, dynamic>?> {
  HesabimCubit() : super(null);

  Future<void> kullaniciBilgileriniYukle() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (doc.exists) {
        emit(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Kullanıcı bilgisi çekme hatası: $e");
    }
  }

  Future<void> kullaniciBilgileriniGuncelle({
    required String ad,
    required String soyad,
    required String dtarih,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection("users").doc(uid).update({
        "ad": ad,
        "soyad": soyad,
        "dtarih": dtarih,
      });
      emit({
        "email": FirebaseAuth.instance.currentUser!.email!,
        "ad": ad,
        "soyad": soyad,
        "dtarih": dtarih,
      });
    } catch (e) {
      print("Güncelleme hatası: $e");
    }
  }
}