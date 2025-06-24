import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ilacim/data/entitiy/repo/ilaclardao_repository.dart';

abstract class KullaniciKayitState {}

class KullaniciKayitInitial extends KullaniciKayitState {}

class KullaniciKayitLoading extends KullaniciKayitState {}

class KullaniciKayitSuccess extends KullaniciKayitState {
  User user;
  KullaniciKayitSuccess(this.user);
}

class KullaniciKayitFailure extends KullaniciKayitState {
  String error;
  KullaniciKayitFailure(this.error);
}

class KullaniciKayitCubit extends Cubit<KullaniciKayitState> {
  KullaniciKayitCubit():super(KullaniciKayitInitial());

  var irepo = IlaclarDaoRepository();

  void kayitOl(String email, String password, String ad, String soyad, String dtarih) async {
    emit(KullaniciKayitLoading()); // Yüklenme durumunu göster
    User? user = await irepo.kayitOl(email, password, ad, soyad, dtarih); // Kaydetme fonksiyonu

    if (user != null) {
      emit(KullaniciKayitSuccess(user)); // Kayıt başarılı
    } else {
      emit(KullaniciKayitFailure("Kayıt başarısız! Lütfen bilgilerinizi kontrol edin.")); // Kayıt başarısız
    }
  }
}
