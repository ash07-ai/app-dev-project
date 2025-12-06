class ShippingAddress {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String address;
  final String city;
  final String zipCode;
  final String? country;
  final bool isDefault;

  ShippingAddress({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.zipCode,
    this.country,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'zipCode': zipCode,
      'country': country,
      'isDefault': isDefault,
    };
  }

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      zipCode: map['zipCode'] ?? '',
      country: map['country'],
      isDefault: map['isDefault'] ?? false,
    );
  }

  ShippingAddress copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? address,
    String? city,
    String? zipCode,
    String? country,
    bool? isDefault,
  }) {
    return ShippingAddress(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get fullAddress => '$address, $city, $zipCode${country != null ? ', $country' : ''}';
}

