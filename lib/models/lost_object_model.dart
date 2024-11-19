class LostObject {
  final String date;
  final String? startStation;
  final String? type;
  final String? nature;

  LostObject({
    required this.date,
    required this.nature,
    required this.type,
    required this.startStation,
  });

  factory LostObject.fromJson(Map<String, dynamic> json) {
    return LostObject(
      date: json['date'],
      startStation: json['station'],
      type: json['type'],
      nature: json['nature'],
    );
  }

}
