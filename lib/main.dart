import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilacim/bildirim/notification_preferences.dart';
import 'package:ilacim/bildirim/notification_service.dart';
import 'package:ilacim/bildirim/plan_notification.dart';
import 'package:ilacim/data/entitiy/repo/ilaclardao_repository.dart';
import 'package:ilacim/ui/cubit/anasayfa_cubit.dart';
import 'package:ilacim/ui/cubit/destek_cubit.dart';
import 'package:ilacim/ui/cubit/hesabim_cubit.dart';
import 'package:ilacim/ui/cubit/ilac_ekleme_sayfa_cubit.dart';
import 'package:ilacim/ui/cubit/ilaclar_sayfa_cubit.dart';
import 'package:ilacim/ui/cubit/istatistik_sayfa_cubit.dart';
import 'package:ilacim/ui/cubit/kullanici_giris_cubit.dart';
import 'package:ilacim/ui/cubit/kullanici_kayit_cubit.dart';
import 'package:ilacim/ui/views/kullanici_giris.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();

  final enabled = await NotificationPreferences.isEnabled();
  final user = FirebaseAuth.instance.currentUser;

  runApp(const MyApp());
  IlaclarDaoRepository().gunlukKullanilanSifirla();
  if (enabled && user != null) {
    await planNotificationsForUser(user.email.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => KullaniciGirisCubit()),
        BlocProvider(create: (context) => KullaniciKayitCubit()),
        BlocProvider(create: (context) => IlacEklemeSayfaCubit()),
        BlocProvider(create: (context) => AnasayfaCubit()),
        BlocProvider(create: (context) => IlaclarSayfaCubit()),
        BlocProvider(create: (context) => IstatistikSayfaCubit()),
        BlocProvider(create: (context) => DestekCubit()),
        BlocProvider(create: (context) => HesabimCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const KullaniciGiris(),
      ),
    );
  }
}
