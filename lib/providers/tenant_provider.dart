import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tenant_model.dart';
import '../services/database_service.dart';

class TenantProvider extends ChangeNotifier {
  final DatabaseService _database;
  List<Tenant> _tenants = [];
  List<Room> _rooms = [];
  List<PaymentRecord> _allPayments = [];

  TenantProvider(this._database);

  List<Tenant> get tenants => _tenants;
  List<Room> get rooms => _rooms;
  List<PaymentRecord> get allPayments => _allPayments;

  Future<void> loadAllData() async {
    try {
      _tenants = await _database.getAllTenants();
      _rooms = await _database.getAllRooms();
      notifyListeners();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> addTenant(Tenant tenant) async {
    try {
      await _database.addTenant(tenant);
      _tenants.add(tenant);
      notifyListeners();
    } catch (e) {
      print('Error adding tenant: $e');
      rethrow;
    }
  }

  Future<void> updateTenant(Tenant tenant) async {
    try {
      await _database.updateTenant(tenant);
      final index = _tenants.indexWhere((t) => t.id == tenant.id);
      if (index != -1) {
        _tenants[index] = tenant;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating tenant: $e');
      rethrow;
    }
  }

  Future<void> deleteTenant(String tenantId) async {
    try {
      await _database.deleteTenant(tenantId);
      _tenants.removeWhere((t) => t.id == tenantId);
      notifyListeners();
    } catch (e) {
      print('Error deleting tenant: $e');
      rethrow;
    }
  }

  Future<void> addRoom(Room room) async {
    try {
      await _database.addRoom(room);
      _rooms.add(room);
      notifyListeners();
    } catch (e) {
      print('Error adding room: $e');
      rethrow;
    }
  }

  Future<void> updateRoom(Room room) async {
    try {
      await _database.updateRoom(room);
      final index = _rooms.indexWhere((r) => r.id == room.id);
      if (index != -1) {
        _rooms[index] = room;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating room: $e');
      rethrow;
    }
  }

  Future<void> addPayment(PaymentRecord payment) async {
    try {
      await _database.addPayment(payment);
      _allPayments.add(payment);
      notifyListeners();
    } catch (e) {
      print('Error adding payment: $e');
      rethrow;
    }
  }

  Future<List<PaymentRecord>> getTenantPayments(String tenantId) async {
    return await _database.getTenantPayments(tenantId);
  }

  double getTotalAdvancePaid(String tenantId) {
    return _allPayments
        .where((p) =>
            p.tenantId == tenantId && p.paymentType == PaymentType.advance)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  double getTotalRentPaid(String tenantId) {
    return _allPayments
        .where((p) =>
            p.tenantId == tenantId && p.paymentType == PaymentType.rent)
        .fold(0.0, (sum, p) => sum + p.amount);
  }
}
