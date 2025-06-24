import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ilaclar.dart';

class IlaclarDaoRepository {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<User?> girisYap(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Giriş Hatası: $e");
      return null;
    }
  }

  Future<User?> kayitOl(String email, String password, String ad, String soyad, String dtarih) async {
    try {
      // Kullanıcıyı Firebase Authentication'a kaydet
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Firestore'a kullanıcı bilgilerini kaydet
        await db.collection("users").doc(user.uid).set({
          "email": email,
          "ad": ad,
          "soyad": soyad,
          "dtarih": dtarih,
        });

        return user;
      }
    } catch (e) {
      print("Kayıt Hatası: $e");
    }
    return null;
  }

  Future<void> ilacEkle(Ilaclar ilac) async {
    var firestore = FirebaseFirestore.instance;
    var ilacRef = firestore.collection("ilaclar");

    var docRef = await ilacRef.add({
      "email": ilac.email,
      "ilacIsim": ilac.ilacIsim,
      "tur": ilac.tur,
      "toplamMiktar": ilac.toplamMiktar,
      "gunlukMiktar": ilac.gunlukMiktar,
      "toplamKullanilan": ilac.toplamKullanilan,
      "gunlukKullanilan": ilac.gunlukKullanilan,
      "zaman": ilac.zaman,
    });

    // Belge ID’sini Firestore’a kaydet
    await docRef.update({"id": docRef.id});
  }

  Future<void> ilacKullaniminiGuncelle(String ilacId) async {
    var ilacRef = FirebaseFirestore.instance.collection("ilaclar").doc(ilacId);

    // Firestore'daki mevcut ilacı çek
    var snapshot = await ilacRef.get();
    if (snapshot.exists) {
      var data = snapshot.data();
      int gunlukKullanilan = int.parse(data?["gunlukKullanilan"] ?? "0");
      int toplamKullanilan = int.parse(data?["toplamKullanilan"] ?? "0");

      if(int.parse(data?["gunlukMiktar"]) > int.parse(data?["gunlukKullanilan"])){
        // Yeni değerleri hesapla
        gunlukKullanilan += 1;
        toplamKullanilan += 1;

        // Güncellenmiş değerleri Firestore'a kaydet
        await ilacRef.update({
          "gunlukKullanilan": gunlukKullanilan.toString(),
          "toplamKullanilan": toplamKullanilan.toString(),
        });

        await ilacKullanimKaydiEkle(
          ilacId: ilacId,
          ilacIsim: data?["ilacIsim"],
          kullaniciEmail: data?["email"],
          miktar: 1,
          tarih: DateTime.now(),
        );
      }
    }
  }

  Future<void> gunlukKullanilanSifirla() async {
    DocumentReference configRef = db.collection('tarih').doc('gun');
    DateTime now = DateTime.now();

    // Veritabanındaki son güncellenme tarihini alıyoruz
    DocumentSnapshot snapshot = await configRef.get();
    DateTime guncellenen = DateTime.parse(snapshot['guncellenen']);

    // Gün değiştiyse sıfırlama yapıyoruz
    if (now.year != guncellenen.year || now.month != guncellenen.month || now.day != guncellenen.day) {
      await gunlukKullanilanSifirlaVeritabaninda();
      await configRef.update({
        'guncellenen': now.toIso8601String(),
      });
    }
  }

  // Günlük kullanım değerini sıfırlama
  Future<void> gunlukKullanilanSifirlaVeritabaninda() async {
    CollectionReference ilaclar = db.collection('ilaclar');
    QuerySnapshot snapshot = await ilaclar.get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({
        'gunlukKullanilan': "0",
      });
    }
  }

  Future<void> yorumEkle(String email, String yorum, String zaman) async {
    var firestore = FirebaseFirestore.instance;
    var ilacRef = firestore.collection("yorumlar");

    await ilacRef.add({
      "email": email,
      "yorum": yorum,
      "zaman": zaman,
    });
  }

  Future<void> ilacKullanimKaydiEkle({
    required String ilacId,
    required String ilacIsim,
    required String kullaniciEmail,
    required int miktar,
    required DateTime tarih,
  }) async {
    await db.collection("kullanici_ilac_kullanimlar").add({
      "ilacId": ilacId,
      "ilacIsim": ilacIsim,
      "email": kullaniciEmail,
      "miktar": miktar,
      "tarih": Timestamp.fromDate(tarih),
    });
  }

}
