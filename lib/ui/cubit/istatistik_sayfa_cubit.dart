import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/data/entitiy/repo/ilaclardao_repository.dart';

class IstatistikSayfaCubit extends Cubit<List<Map<String, dynamic>>> {
  IstatistikSayfaCubit() : super([]);

  var irepo = IlaclarDaoRepository();

  void getIstatistikVerisi(DateTime haftaTarihi) async {
    DateTime baslangic = haftaTarihi.subtract(Duration(days: haftaTarihi.weekday - 1));
    DateTime bitis = baslangic.add(const Duration(days: 6));
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    FirebaseFirestore.instance
        .collection("kullanici_ilac_kullanimlar")
        .where("email", isEqualTo: email)
        .where("tarih", isGreaterThanOrEqualTo: Timestamp.fromDate(baslangic))
        .where("tarih", isLessThanOrEqualTo: Timestamp.fromDate(bitis))
        .snapshots()
        .listen((snapshot) {
      Map<String, Map<int, int>> sonuc = {};

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String ilacIsim = data["ilacIsim"];
        DateTime tarih = (data["tarih"] as Timestamp).toDate();
        int miktar = data["miktar"];

        int gunIndex = tarih.weekday - 1;

        sonuc.putIfAbsent(ilacIsim, () => {});
        sonuc[ilacIsim]![gunIndex] = (sonuc[ilacIsim]![gunIndex] ?? 0) + miktar;
      }

      emit(sonuc.entries.map((e) => {"ilacIsim": e.key, "gunler": e.value}).toList());
    });
  }
}