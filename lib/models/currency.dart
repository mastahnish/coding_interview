enum CurrencyType { fiat, crypto }

class Currency {
  final String id;
  final String name;
  final String symbol;
  final CurrencyType type;
  final String imagePath;

  const Currency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.type,
    required this.imagePath,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      type: json['type'] == 'crypto' ? CurrencyType.crypto : CurrencyType.fiat,
      imagePath: json['imagePath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'symbol': symbol, 'type': type.name, 'imagePath': imagePath};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Currency && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Currency(id: $id, name: $name, symbol: $symbol, type: $type)';
  }
}
