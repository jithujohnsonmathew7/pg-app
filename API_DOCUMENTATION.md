# PG Management App - Developer Documentation

## Architecture Overview

```
┌─────────────────────────────────────┐
│          UI Layer (Screens)         │
│  Dashboard | Tenants | Rooms | Add  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│       State Management (Provider)   │
│         TenantProvider              │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Services (Business Logic)      │
│      DatabaseService               │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Data Layer (Hive Database)     │
│   Tenants | Rooms | Payments        │
└─────────────────────────────────────┘
```

## Module Breakdown

### 1. Models (`lib/models/`)

#### TenantModel
The core data model for the application.

```dart
class Tenant {
  final String id;                    // Unique identifier
  final String name;
  final String email;
  final String phone;
  final String address;
  final String aadharNumber;          // Indian Aadhar ID
  final String roomId;                // References Room.id
  final DateTime checkInDate;
  final DateTime? checkOutDate;       // When tenant leaves
  final List<PaymentRecord> payments; // Embedded payments
  final double advanceAmount;         // Total advance paid
  final double monthlyRent;           // Assigned rent
  final FoodPreference foodPreference;
  final VehicleDetail? vehicleDetail; // Optional vehicle
  final bool isActive;                // Soft delete
}
```

#### PaymentRecord
Tracks all financial transactions.

```dart
class PaymentRecord {
  final String id;
  final String tenantId;              // Foreign key to Tenant
  final double amount;
  final PaymentType paymentType;      // rent | advance | security_deposit | other
  final DateTime paymentDate;
  final String? notes;                // Optional transaction notes
}
```

#### Room
Property room details and status.

```dart
class Room {
  final String id;
  final String roomNumber;            // Display identifier (101, 201, etc.)
  final int capacity;                 // Number of occupants
  final double monthlyRent;
  final String? currentTenantId;      // Current occupant reference
  final String? description;
  final List<String> amenities;       // WiFi, AC, Bath type, etc.
  final bool isAvailable;             // Availability status
}
```

#### VehicleDetail
Optional vehicle information for tenants.

```dart
class VehicleDetail {
  final String type;                  // Car, Bike, Scooter, etc.
  final String registrationNumber;    // License plate
  final String? model;
  final String? color;
  final DateTime? registrationExpiry;
}
```

#### Enums

```dart
enum FoodPreference {
  vegetarian,
  nonVegetarian,
  vegan,
  jain,
}

enum PaymentType {
  rent,
  advance,
  securityDeposit,
  other,
}
```

### 2. Services (`lib/services/`)

#### DatabaseService

Core database operations using Hive.

**Key Methods:**

```dart
// Initialization
Future<void> initDatabase()

// Tenant Operations
Future<void> addTenant(Tenant tenant)
Future<void> updateTenant(Tenant tenant)
Future<void> deleteTenant(String tenantId)
Future<Tenant?> getTenant(String tenantId)
Future<List<Tenant>> getAllTenants()
Future<List<Tenant>> getActiveTenants()

// Room Operations
Future<void> addRoom(Room room)
Future<void> updateRoom(Room room)
Future<Room?> getRoom(String roomId)
Future<List<Room>> getAllRooms()
Future<List<Room>> getAvailableRooms()

// Payment Operations
Future<void> addPayment(PaymentRecord payment)
Future<List<PaymentRecord>> getTenantPayments(String tenantId)

// Utility
Future<void> clearAllData()
```

### 3. State Management (`lib/providers/`)

#### TenantProvider (ChangeNotifier)

Manages all app state using Provider pattern.

**Properties:**
```dart
List<Tenant> _tenants          // All stored tenants
List<Room> _rooms              // All rooms
List<PaymentRecord> _allPayments // All payments
DatabaseService _database      // Database reference
```

**Key Methods:**
```dart
// Data Loading
Future<void> loadAllData()

// Tenant Management
Future<void> addTenant(Tenant tenant)
Future<void> updateTenant(Tenant tenant)
Future<void> deleteTenant(String tenantId)

// Room Management
Future<void> addRoom(Room room)

// Payment Management
Future<void> addPayment(PaymentRecord payment)
Future<List<PaymentRecord>> getTenantPayments(String tenantId)

// Calculations
double getTotalAdvancePaid(String tenantId)
double getTotalRentPaid(String tenantId)
```

### 4. Screens (`lib/screens/`)

#### DashboardScreen
Overview of key metrics and recent activity.

**Displays:**
- Active tenant count
- Available rooms ratio
- Monthly rent potential
- Total advance collected
- Recent tenants list

#### TenantsListScreen
Lists all active tenants with quick actions.

**Features:**
- Search/filter tenants
- Quick view tenant info
- Navigate to detail screen
- FAB to add new tenant

#### TenantDetailScreen
Comprehensive tenant information with tabbed interface.

**Tabs:**
1. **Personal** - Basic info, room assignment, preferences
2. **Payment** - Payment history, quick add payment, summaries
3. **Vehicle** - Vehicle details (if available)

**Actions:**
- Add rent payment
- Add advance payment
- Remove tenant

#### AddTenantScreen
Form to add new tenant with validation.

**Sections:**
1. Basic Information (name, email, phone, address, aadhar)
2. Room & Preferences (room selection, food preference)
3. Payment Information (rent, advance)
4. Vehicle Details (optional)

#### RoomManagementScreen
Manage property rooms.

**Features:**
- Grid view of rooms
- Display room number, capacity, rent
- Show availability status
- Add new room via dialog

## Data Flow

### Adding a Tenant

```
User Input (AddTenantScreen)
    ↓
Form Validation
    ↓
Create Tenant Object
    ↓
TenantProvider.addTenant()
    ↓
DatabaseService.addTenant()
    ↓
Hive Storage
    ↓
notifyListeners() → UI Update
```

### Recording Payment

```
User Action (TenantDetailScreen)
    ↓
Payment Dialog Input
    ↓
Create PaymentRecord
    ↓
TenantProvider.addPayment()
    ↓
DatabaseService.addPayment()
    ↓
Hive Storage
    ↓
notifyListeners() → UI Update
    ↓
Recalculate totals
```

### Loading Data

```
App Start (main.dart)
    ↓
Initialize Database
    ↓
Create TenantProvider
    ↓
TenantProvider.loadAllData()
    ↓
DatabaseService.getAllTenants/Rooms/Payments
    ↓
Hive Query Results
    ↓
Populate _tenants, _rooms, _allPayments
    ↓
notifyListeners() → UI Renders
```

## Database Schema

### Hive Boxes

**Box: tenants**
```
Key: Tenant.id (String)
Value: Tenant Object (JSON)
{
  "id": "uuid",
  "name": "string",
  "email": "string",
  "phone": "string",
  "address": "string",
  "aadharNumber": "string",
  "roomId": "string",
  "checkInDate": "datetime",
  "checkOutDate": "datetime",
  "payments": [],
  "advanceAmount": number,
  "monthlyRent": number,
  "foodPreference": "enum",
  "vehicleDetail": { ... },
  "isActive": boolean
}
```

**Box: rooms**
```
Key: Room.id (String)
Value: Room Object (JSON)
{
  "id": "uuid",
  "roomNumber": "string",
  "capacity": number,
  "monthlyRent": number,
  "currentTenantId": "string",
  "description": "string",
  "amenities": ["string"],
  "isAvailable": boolean
}
```

**Box: payments**
```
Key: PaymentRecord.id (String)
Value: PaymentRecord Object (JSON)
{
  "id": "uuid",
  "tenantId": "string",
  "amount": number,
  "paymentType": "enum",
  "paymentDate": "datetime",
  "notes": "string"
}
```

## API Reference

### TenantProvider Methods

#### `loadAllData()`
Loads all tenants, rooms, and payments from database.

```dart
Future<void> loadAllData() async {
  _tenants = await _database.getAllTenants();
  _rooms = await _database.getAllRooms();
  notifyListeners();
}
```

#### `addTenant(Tenant tenant)`
Adds new tenant to system.

```dart
await provider.addTenant(tenant);
// Automatically updates UI
```

#### `getTotalAdvancePaid(String tenantId)`
Calculates total advance payment for a tenant.

```dart
double advance = provider.getTotalAdvancePaid(tenantId);
```

#### `getTenantPayments(String tenantId)`
Retrieves all payment records for a specific tenant.

```dart
List<PaymentRecord> payments = 
  await provider.getTenantPayments(tenantId);
```

## Adding New Features

### Example: Add Maintenance Records

1. **Create Model** (`lib/models/maintenance_model.dart`)
```dart
class MaintenanceRecord {
  final String id;
  final String roomId;
  final String description;
  final double cost;
  final DateTime date;
  // ... other fields
}
```

2. **Update Database Service**
```dart
Future<void> addMaintenance(MaintenanceRecord record) async {
  await maintenanceBox.put(record.id, record.toJson());
}
```

3. **Update Provider**
```dart
Future<void> addMaintenance(MaintenanceRecord record) async {
  await _database.addMaintenance(record);
  notifyListeners();
}
```

4. **Create Screen** (`lib/screens/maintenance_screen.dart`)

5. **Add Navigation** in main.dart

## Error Handling

### Database Errors
```dart
try {
  await database.addTenant(tenant);
} catch (e) {
  print('Error: $e');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e'))
  );
}
```

### Form Validation
```dart
TextFormField(
  validator: (value) {
    if (value?.isEmpty ?? true) {
      return 'This field is required';
    }
    return null;
  }
)
```

## Performance Optimization

1. **Data Caching**: Provider caches all data in memory
2. **Lazy Loading**: Use FutureBuilder for expensive operations
3. **Indexed Queries**: Hive indexes on keys automatically
4. **Efficient Rebuilds**: Consumer widget limits rebuilds
5. **Memory Management**: Clear data when not needed

## Testing

### Unit Tests for Models
```dart
test('Tenant copyWith works correctly', () {
  final tenant1 = Tenant(...);
  final tenant2 = tenant1.copyWith(name: 'New Name');
  expect(tenant2.name, 'New Name');
});
```

### Widget Tests for Screens
```dart
testWidgets('TenantsList displays tenants', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.byType(ListTile), findsWidgets);
});
```

## Deployment Checklist

- [ ] All features tested on device
- [ ] No console errors/warnings
- [ ] App performance tested with >100 tenants
- [ ] Backup functionality working
- [ ] UI responsive on different screen sizes
- [ ] Database integrity verified
- [ ] Memory leaks addressed
- [ ] Release build tested

---

**Last Updated**: January 16, 2026
