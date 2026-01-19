// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tenant _$TenantFromJson(Map<String, dynamic> json) => Tenant(
      id: json['id'] as String,
  pgId: (json['pgId'] as String?) ?? 'default-pg',
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      aadharNumber: json['aadharNumber'] as String,
      roomId: json['roomId'] as String,
      checkInDate: DateTime.parse(json['checkInDate'] as String),
      checkOutDate: json['checkOutDate'] == null
          ? null
          : DateTime.parse(json['checkOutDate'] as String),
      payments: (json['payments'] as List<dynamic>?)
              ?.map((e) => PaymentRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      advanceAmount: (json['advanceAmount'] as num?)?.toDouble() ?? 0.0,
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble() ?? 0.0,
      foodPreference: $enumDecodeNullable(
              _$FoodPreferenceEnumMap, json['foodPreference']) ??
          FoodPreference.vegetarian,
      vehicleDetail: json['vehicleDetail'] == null
          ? null
          : VehicleDetail.fromJson(
              json['vehicleDetail'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$TenantToJson(Tenant instance) => <String, dynamic>{
      'id': instance.id,
      'pgId': instance.pgId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'aadharNumber': instance.aadharNumber,
      'roomId': instance.roomId,
      'checkInDate': instance.checkInDate.toIso8601String(),
      'checkOutDate': instance.checkOutDate?.toIso8601String(),
      'payments': instance.payments,
      'advanceAmount': instance.advanceAmount,
      'monthlyRent': instance.monthlyRent,
      'foodPreference': _$FoodPreferenceEnumMap[instance.foodPreference]!,
      'vehicleDetail': instance.vehicleDetail,
      'isActive': instance.isActive,
    };

const _$FoodPreferenceEnumMap = {
  FoodPreference.vegetarian: 'vegetarian',
  FoodPreference.nonVegetarian: 'non_vegetarian',
  FoodPreference.vegan: 'vegan',
  FoodPreference.jain: 'jain',
};

PaymentRecord _$PaymentRecordFromJson(Map<String, dynamic> json) =>
    PaymentRecord(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentType: $enumDecode(_$PaymentTypeEnumMap, json['paymentType']),
      paymentDate: DateTime.parse(json['paymentDate'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$PaymentRecordToJson(PaymentRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'amount': instance.amount,
      'paymentType': _$PaymentTypeEnumMap[instance.paymentType]!,
      'paymentDate': instance.paymentDate.toIso8601String(),
      'notes': instance.notes,
    };

const _$PaymentTypeEnumMap = {
  PaymentType.rent: 'rent',
  PaymentType.advance: 'advance',
  PaymentType.securityDeposit: 'security_deposit',
  PaymentType.other: 'other',
};

VehicleDetail _$VehicleDetailFromJson(Map<String, dynamic> json) =>
    VehicleDetail(
      type: json['type'] as String,
      registrationNumber: json['registrationNumber'] as String,
      model: json['model'] as String?,
      color: json['color'] as String?,
      registrationExpiry: json['registrationExpiry'] == null
          ? null
          : DateTime.parse(json['registrationExpiry'] as String),
    );

Map<String, dynamic> _$VehicleDetailToJson(VehicleDetail instance) =>
    <String, dynamic>{
      'type': instance.type,
      'registrationNumber': instance.registrationNumber,
      'model': instance.model,
      'color': instance.color,
      'registrationExpiry': instance.registrationExpiry?.toIso8601String(),
    };

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      id: json['id'] as String,
  pgId: (json['pgId'] as String?) ?? 'default-pg',
      roomNumber: json['roomNumber'] as String,
      capacity: (json['capacity'] as num).toInt(),
      monthlyRent: (json['monthlyRent'] as num).toDouble(),
      currentTenantId: json['currentTenantId'] as String?,
      description: json['description'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'pgId': instance.pgId,
      'roomNumber': instance.roomNumber,
      'capacity': instance.capacity,
      'monthlyRent': instance.monthlyRent,
      'currentTenantId': instance.currentTenantId,
      'description': instance.description,
      'amenities': instance.amenities,
      'isAvailable': instance.isAvailable,
    };

PgProperty _$PgPropertyFromJson(Map<String, dynamic> json) => PgProperty(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$PgPropertyToJson(PgProperty instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
    };
