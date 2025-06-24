import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_service.dart';
import 'package:intl/intl.dart';

Future<void> planNotificationsForUser(String userId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection("ilaclar")
      .where("email", isEqualTo: userId) // email olarak filtreleniyor
      .get();

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final ilacId = doc.id;
    final ilacIsmi = data["ilacIsim"];
    final zamanString = data["zaman"];
    final zamanlar = zamanString.split(",");

    for (int i = 0; i < zamanlar.length; i++) {
      final zaman = zamanlar[i].trim();

      try {
        final cleaned = zaman.replaceAll(RegExp(r'\s+'), ' ').trim(); // fazlalık boşlukları düzelt
        final parsedTime = DateFormat('h:mm a').parse(cleaned); // AM/PM formatına uygun şekilde parse et

        final now = DateTime.now();
        final scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          parsedTime.hour,
          parsedTime.minute,
        );

        final finalScheduledTime = scheduledTime.isBefore(now)
            ? scheduledTime.add(Duration(days: 1))
            : scheduledTime;

        await NotificationService.showScheduledNotification(
          id: (ilacId + "_$i").hashCode,
          title: "İlaç Hatırlatma",
          body: "$ilacIsmi ilacını almayı unutma!",
          scheduledTime: finalScheduledTime,
        );
      } catch (e) {
        print("Hatalı zaman biçimi: '$zaman' – $e");
      }
    }
  }
}
