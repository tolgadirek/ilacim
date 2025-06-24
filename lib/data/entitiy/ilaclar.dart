class Ilaclar {
  String id;
  String email;
  String ilacIsim;
  String tur;
  String toplamMiktar;
  String gunlukMiktar;
  String toplamKullanilan;
  String gunlukKullanilan;
  String zaman;

  Ilaclar({
    required this.id,  // ID'yi required olarak ekledik
    required this.email,
    required this.ilacIsim,
    required this.tur,
    required this.toplamMiktar,
    required this.gunlukMiktar,
    required this.toplamKullanilan,
    required this.gunlukKullanilan,
    required this.zaman,
  });

  factory Ilaclar.fromJson(Map<dynamic, dynamic> json, String key) {
    return Ilaclar(
      id: key,  // JSON’dan gelen key’i ID olarak saklıyoruz
      email: json["email"] as String,
      ilacIsim: json["ilacIsim"] as String,
      tur: json["tur"] as String,
      toplamMiktar: json["toplamMiktar"] as String,
      gunlukMiktar: json["gunlukMiktar"] as String,
      toplamKullanilan: json["toplamKullanilan"] as String,
      gunlukKullanilan: json["gunlukKullanilan"] as String,
      zaman: json["zaman"] as String,
    );
  }
}