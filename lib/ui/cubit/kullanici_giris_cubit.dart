import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ilacim/data/entitiy/repo/ilaclardao_repository.dart';

abstract class KullaniciGirisState {}

class KullaniciGirisInitial extends KullaniciGirisState {}

class KullaniciGirisLoading extends KullaniciGirisState {}

class KullaniciGirisSuccess extends KullaniciGirisState {
  User user;
  KullaniciGirisSuccess(this.user);
}

class KullaniciGirisFailure extends KullaniciGirisState {
  String error;
  KullaniciGirisFailure(this.error);
}

class KullaniciGirisCubit extends Cubit<KullaniciGirisState> {
  KullaniciGirisCubit():super(KullaniciGirisInitial());

  var irepo = IlaclarDaoRepository();

  void girisYap(String email, String password) async {
    emit(KullaniciGirisLoading()); // Yüklenme durumunu göster
    User? user = await irepo.girisYap(email, password);
    if (user != null) {
      emit(KullaniciGirisSuccess(user)); // Giriş başarılı
    } else {
      emit(KullaniciGirisFailure("Giriş başarısız! Lütfen bilgilerinizi kontrol edin.")); // Giriş başarısız
    }
  }
}
