class AsmaaAllahModel {
  final int id;
  final String name;
  final String meaning;
  final String? benefit;

  AsmaaAllahModel({
    required this.id,
    required this.name,
    required this.meaning,
    this.benefit,
  });

  factory AsmaaAllahModel.fromJson(Map<String, dynamic> json) {
    return AsmaaAllahModel(
      id: json['id'],
      name: json['name'],
      meaning: json['meaning'],
      benefit: json['benefit'],
    );
  }
}
