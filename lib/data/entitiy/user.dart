class User {
  String email;
  String ad;
  String soyad;
  String dtarih;

  User({required this.email, required this.ad, required this.soyad, required this.dtarih});

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      email: json["email"] as String,
      ad: json["ad"] as String,
      soyad: json["soyad"] as String,
      dtarih: json["dtarih"] as String
    );
  }
}