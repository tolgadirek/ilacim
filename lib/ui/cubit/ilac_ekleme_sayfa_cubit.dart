import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/data/entitiy/ilaclar.dart';
import 'package:ilacim/data/entitiy/repo/ilaclardao_repository.dart';

class IlacEklemeSayfaCubit extends Cubit<void> {
  IlacEklemeSayfaCubit():super(0);

  var irepo = IlaclarDaoRepository();

  Future<void> ilacEkle(Ilaclar ilac) async {
    await irepo.ilacEkle(ilac);
  }
}