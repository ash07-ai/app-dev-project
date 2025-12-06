class PaymentMethod {
  final String id;
  final String type; // 'credit_card', 'paypal', 'debit_card'
  final String? cardNumber; // Last 4 digits for display
  final String? cardHolderName;
  final String? expiryDate; // MM/YY
  final String? billingAddress;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    this.cardNumber,
    this.cardHolderName,
    this.expiryDate,
    this.billingAddress,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'billingAddress': billingAddress,
      'isDefault': isDefault,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      cardNumber: map['cardNumber'],
      cardHolderName: map['cardHolderName'],
      expiryDate: map['expiryDate'],
      billingAddress: map['billingAddress'],
      isDefault: map['isDefault'] ?? false,
    );
  }

  PaymentMethod copyWith({
    String? id,
    String? type,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? billingAddress,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      type: type ?? this.type,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      billingAddress: billingAddress ?? this.billingAddress,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get displayName {
    switch (type) {
      case 'credit_card':
        return cardNumber != null ? 'Card ending in ${cardNumber!.substring(cardNumber!.length - 4)}' : 'Credit Card';
      case 'debit_card':
        return cardNumber != null ? 'Debit Card ending in ${cardNumber!.substring(cardNumber!.length - 4)}' : 'Debit Card';
      case 'paypal':
        return 'PayPal';
      default:
        return type;
    }
  }
}

