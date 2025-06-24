import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/data/entitiy/repo/ilaclardao_repository.dart';

class DestekCubit extends Cubit<void> {
  DestekCubit():super(0);

  var irepo = IlaclarDaoRepository();

  Future<void> yorumEkle(String email, String yorum, String zaman) async {
    await irepo.yorumEkle(email, yorum, zaman);
  }
}