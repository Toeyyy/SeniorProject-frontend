class SignalmentObject {
  String species;
  String breed;
  bool sterilize;
  String age;
  String sex;
  String weight;

  SignalmentObject(
      {required this.species,
      required this.breed,
      required this.sterilize,
      required this.age,
      required this.sex,
      required this.weight});

  factory SignalmentObject.fromJson(Map<String, dynamic> json) {
    return SignalmentObject(
        species: json['species'] ?? "",
        breed: json['breed'] ?? "",
        sterilize: json['sterilize'] ?? "",
        age: json['age'] ?? "",
        sex: json['sex'] ?? "",
        weight: json['weight'] ?? "");
  }
}
