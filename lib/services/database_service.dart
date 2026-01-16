import 'package:hive/hive.dart';
import '../models/tenant_model.dart';

class DatabaseService {
  static const String tenantBoxName = 'tenants';
  static const String roomBoxName = 'rooms';
  static const String paymentBoxName = 'payments';

  late Box<Map> tenantBox;
  late Box<Map> roomBox;
  late Box<Map> paymentBox;

  Future<void> initDatabase() async {
    try {
      tenantBox = await Hive.openBox<Map>(tenantBoxName);
      roomBox = await Hive.openBox<Map>(roomBoxName);
      paymentBox = await Hive.openBox<Map>(paymentBoxName);
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  // Tenant Operations
  Future<void> addTenant(Tenant tenant) async {
    await tenantBox.put(tenant.id, tenant.toJson());
  }

  Future<void> updateTenant(Tenant tenant) async {
    await tenantBox.put(tenant.id, tenant.toJson());
  }

  Future<void> deleteTenant(String tenantId) async {
    await tenantBox.delete(tenantId);
  }

  Future<Tenant?> getTenant(String tenantId) async {
    final data = tenantBox.get(tenantId);
    if (data != null) {
      return Tenant.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<List<Tenant>> getAllTenants() async {
    final tenants = <Tenant>[];
    for (var value in tenantBox.values) {
      tenants.add(Tenant.fromJson(Map<String, dynamic>.from(value)));
    }
    return tenants;
  }

  Future<List<Tenant>> getActiveTenants() async {
    final allTenants = await getAllTenants();
    return allTenants.where((t) => t.isActive).toList();
  }

  // Room Operations
  Future<void> addRoom(Room room) async {
    await roomBox.put(room.id, room.toJson());
  }

  Future<void> updateRoom(Room room) async {
    await roomBox.put(room.id, room.toJson());
  }

  Future<Room?> getRoom(String roomId) async {
    final data = roomBox.get(roomId);
    if (data != null) {
      return Room.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<List<Room>> getAllRooms() async {
    final rooms = <Room>[];
    for (var value in roomBox.values) {
      rooms.add(Room.fromJson(Map<String, dynamic>.from(value)));
    }
    return rooms;
  }

  Future<List<Room>> getAvailableRooms() async {
    final allRooms = await getAllRooms();
    return allRooms.where((r) => r.isAvailable).toList();
  }

  // Payment Operations
  Future<void> addPayment(PaymentRecord payment) async {
    await paymentBox.put(payment.id, payment.toJson());
  }

  Future<List<PaymentRecord>> getTenantPayments(String tenantId) async {
    final payments = <PaymentRecord>[];
    for (var value in paymentBox.values) {
      final payment = PaymentRecord.fromJson(Map<String, dynamic>.from(value));
      if (payment.tenantId == tenantId) {
        payments.add(payment);
      }
    }
    return payments..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
  }

  Future<void> clearAllData() async {
    await tenantBox.clear();
    await roomBox.clear();
    await paymentBox.clear();
  }
}
