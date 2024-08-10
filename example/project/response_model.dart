class ResponseModel {
  final String name;
  final String framework;

  ResponseModel({required this.name, required this.framework});

  // JSON'dan Dart nesnesine dönüştürme
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      name: json['name'] as String,
      framework: json['framework'] as String,
    );
  }

  // Dart nesnesinden JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'framework': framework,
    };
  }
}
