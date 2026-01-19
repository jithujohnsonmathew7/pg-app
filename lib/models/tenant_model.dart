import 'package:json_annotation/json_annotation.dart';

part 'tenant_model.g.dart';

@JsonSerializable()
class Tenant {
  final String id;
  final String pgId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String aadharNumber;
  final String roomId;
  final DateTime checkInDate;
  final DateTime? checkOutDate;
  final List<PaymentRecord> payments;
  final double advanceAmount;
  final double monthlyRent;
  final FoodPreference foodPreference;
  final VehicleDetail? vehicleDetail;
  final bool isActive;

  Tenant({
    required this.id,
    required this.pgId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.aadharNumber,
    required this.roomId,
    required this.checkInDate,
    this.checkOutDate,
    this.payments = const [],
    this.advanceAmount = 0.0,
    this.monthlyRent = 0.0,
    this.foodPreference = FoodPreference.vegetarian,
    this.vehicleDetail,
    this.isActive = true,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);
  Map<String, dynamic> toJson() => _$TenantToJson(this);

  Tenant copyWith({
    String? id,
    String? pgId,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? aadharNumber,
    String? roomId,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    List<PaymentRecord>? payments,
    double? advanceAmount,
    double? monthlyRent,
    FoodPreference? foodPreference,
    VehicleDetail? vehicleDetail,
    bool? isActive,
  }) {
    return Tenant(
      id: id ?? this.id,
      pgId: pgId ?? this.pgId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      roomId: roomId ?? this.roomId,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      payments: payments ?? this.payments,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      foodPreference: foodPreference ?? this.foodPreference,
      vehicleDetail: vehicleDetail ?? this.vehicleDetail,
      isActive: isActive ?? this.isActive,
    );
  }
}

@JsonSerializable()
class PaymentRecord {
  final String id;
  final String tenantId;
  final double amount;
  final PaymentType paymentType;
  final DateTime paymentDate;
  final String? notes;

  PaymentRecord({
    required this.id,
    required this.tenantId,
    required this.amount,
    required this.paymentType,
    required this.paymentDate,
    this.notes,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) =>
      _$PaymentRecordFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRecordToJson(this);
}

@JsonSerializable()
class VehicleDetail {
  final String type; // Car, Bike, Scooter, etc.
  final String registrationNumber;
  final String? model;
  final String? color;
  final DateTime? registrationExpiry;

  VehicleDetail({
    required this.type,
    required this.registrationNumber,
    this.model,
    this.color,
    this.registrationExpiry,
  });

  factory VehicleDetail.fromJson(Map<String, dynamic> json) =>
      _$VehicleDetailFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleDetailToJson(this);
}

@JsonSerializable()
class Room {
  final String id;
  final String pgId;
  final String roomNumber;
  final int capacity;
  final double monthlyRent;
  final String? currentTenantId;
  final String? description;
  final List<String> amenities;
  final bool isAvailable;

  Room({
    required this.id,
    required this.pgId,
    required this.roomNumber,
    required this.capacity,
    required this.monthlyRent,
    this.currentTenantId,
    this.description,
    this.amenities = const [],
    this.isAvailable = true,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);
}

@JsonSerializable()
class PgProperty {
  final String id;
  final String name;
  final String? address;

  PgProperty({
    required this.id,
    required this.name,
    this.address,
  });

  factory PgProperty.fromJson(Map<String, dynamic> json) =>
      _$PgPropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PgPropertyToJson(this);
}

enum FoodPreference {
  @JsonValue('vegetarian')
  vegetarian,
  @JsonValue('non_vegetarian')
  nonVegetarian,
  @JsonValue('vegan')
  vegan,
  @JsonValue('jain')
  jain,
}

enum PaymentType {
  @JsonValue('rent')
  rent,
  @JsonValue('advance')
  advance,
  @JsonValue('security_deposit')
  securityDeposit,
  @JsonValue('other')
  other,
}
