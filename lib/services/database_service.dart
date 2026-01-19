import 'package:hive/hive.dart';
import '../models/tenant_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  static const String tenantBoxName = 'tenants';
  static const String roomBoxName = 'rooms';
  static const String paymentBoxName = 'payments';
  static const String pgBoxName = 'pgs';
  static const String userBoxName = 'users';

  late Box<Map> tenantBox;
  late Box<Map> roomBox;
  late Box<Map> paymentBox;
  late Box<Map> pgBox;
  late Box<Map> userBox;

  Future<void> initDatabase() async {
    try {
      tenantBox = await Hive.openBox<Map>(tenantBoxName);
      roomBox = await Hive.openBox<Map>(roomBoxName);
      paymentBox = await Hive.openBox<Map>(paymentBoxName);
      pgBox = await Hive.openBox<Map>(pgBoxName);
      userBox = await Hive.openBox<Map>(userBoxName);
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  // PG Operations
  Future<void> addPg(PgProperty pg) async {
    await pgBox.put(pg.id, pg.toJson());
  }

  Future<void> updatePg(PgProperty pg) async {
    await pgBox.put(pg.id, pg.toJson());
  }

  Future<List<PgProperty>> getAllPgs() async {
    final pgs = <PgProperty>[];
    for (var value in pgBox.values) {
      pgs.add(PgProperty.fromJson(Map<String, dynamic>.from(value)));
    }
    return pgs;
  }

  // User Operations
  Future<void> addUser(User user) async {
    await userBox.put(user.id, user.toJson());
  }

  Future<void> updateUser(User user) async {
    await userBox.put(user.id, user.toJson());
  }

  Future<User?> getUser(String userId) async {
    final data = userBox.get(userId);
    if (data != null) {
      return User.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final users = <User>[];
    for (var value in userBox.values) {
      users.add(User.fromJson(Map<String, dynamic>.from(value)));
    }
    return users;
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

  Future<List<PaymentRecord>> getAllPayments() async {
    final payments = <PaymentRecord>[];
    for (var value in paymentBox.values) {
      payments.add(PaymentRecord.fromJson(Map<String, dynamic>.from(value)));
    }
    return payments;
  }

  Future<void> clearAllData() async {
    await tenantBox.clear();
    await roomBox.clear();
    await paymentBox.clear();
    await pgBox.clear();
    await userBox.clear();
  }
}
