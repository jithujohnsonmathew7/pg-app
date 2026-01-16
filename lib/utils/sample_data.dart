// This file contains example data for testing the app

import 'package:uuid/uuid.dart';
import '../models/tenant_model.dart';

class SampleData {
  static List<Room> getSampleRooms() {
    return [
      Room(
        id: const Uuid().v4(),
        roomNumber: '101',
        capacity: 1,
        monthlyRent: 5000,
        description: 'Single room with attached bathroom',
        amenities: const ['WiFi', 'AC', 'Attached Bath'],
        isAvailable: true,
      ),
      Room(
        id: const Uuid().v4(),
        roomNumber: '102',
        capacity: 2,
        monthlyRent: 8000,
        description: 'Double sharing room',
        amenities: const ['WiFi', 'AC', 'Shared Bath'],
        isAvailable: true,
      ),
      Room(
        id: const Uuid().v4(),
        roomNumber: '201',
        capacity: 1,
        monthlyRent: 5500,
        description: 'Single room with attached bathroom',
        amenities: const ['WiFi', 'AC', 'Attached Bath', 'Window'],
        isAvailable: false,
      ),
      Room(
        id: const Uuid().v4(),
        roomNumber: '202',
        capacity: 3,
        monthlyRent: 12000,
        description: 'Triple sharing room',
        amenities: const ['WiFi', 'AC', 'Shared Bath'],
        isAvailable: true,
      ),
    ];
  }

  static List<Tenant> getSampleTenants(List<Room> rooms) {
    final room1 = rooms.firstWhere((r) => r.roomNumber == '101');
    final room2 = rooms.firstWhere((r) => r.roomNumber == '102');

    return [
      Tenant(
        id: const Uuid().v4(),
        name: 'Rajesh Kumar',
        email: 'rajesh@example.com',
        phone: '9876543210',
        address: '123 Main Street, City',
        aadharNumber: '123456789012',
        roomId: room1.id,
        checkInDate: DateTime(2024, 1, 15),
        advanceAmount: 10000,
        monthlyRent: 5000,
        foodPreference: FoodPreference.vegetarian,
        vehicleDetail: VehicleDetail(
          type: 'Bike',
          registrationNumber: 'DL01AB1234',
          model: 'Honda CB350',
          color: 'Black',
        ),
        isActive: true,
        payments: [],
      ),
      Tenant(
        id: const Uuid().v4(),
        name: 'Priya Singh',
        email: 'priya@example.com',
        phone: '9876543211',
        address: '456 Oak Avenue, City',
        aadharNumber: '234567890123',
        roomId: room2.id,
        checkInDate: DateTime(2024, 2, 20),
        advanceAmount: 16000,
        monthlyRent: 8000,
        foodPreference: FoodPreference.nonVegetarian,
        vehicleDetail: VehicleDetail(
          type: 'Car',
          registrationNumber: 'DL02CD5678',
          model: 'Maruti Swift',
          color: 'Red',
        ),
        isActive: true,
        payments: [],
      ),
    ];
  }

  static List<PaymentRecord> getSamplePayments(List<Tenant> tenants) {
    if (tenants.isEmpty) return [];

    return [
      PaymentRecord(
        id: const Uuid().v4(),
        tenantId: tenants[0].id,
        amount: 10000,
        paymentType: PaymentType.advance,
        paymentDate: DateTime(2024, 1, 15),
        notes: 'Initial advance deposit',
      ),
      PaymentRecord(
        id: const Uuid().v4(),
        tenantId: tenants[0].id,
        amount: 5000,
        paymentType: PaymentType.rent,
        paymentDate: DateTime(2024, 2, 1),
        notes: 'January rent',
      ),
      PaymentRecord(
        id: const Uuid().v4(),
        tenantId: tenants[1].id,
        amount: 16000,
        paymentType: PaymentType.advance,
        paymentDate: DateTime(2024, 2, 20),
        notes: 'Two months advance',
      ),
    ];
  }
}
