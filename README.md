# PG Management App

A comprehensive Flutter application for managing paying guest (PG) properties. This app helps PG owners track tenants, manage payments, maintain room information, and monitor vehicle details.

## Features

### 1. **Tenant Management**
- Add new tenants with complete information
- Store essential details:
  - Name, Email, Phone, Address
  - Aadhar Number
  - Room Assignment
  - Check-in/Check-out dates
  - Current active status
- View tenant profiles
- Remove/deactivate tenants

### 2. **Payment Tracking**
- Record advance payments
- Track monthly rent payments
- Maintain payment history
- View payment summaries per tenant
- Notes for each payment

### 3. **Room Management**
- Create and manage room inventory
- Set room capacity and monthly rent
- Track room availability
- Add room descriptions and amenities

### 4. **Tenant Information**
- **Personal Details**: Name, contact info, address, Aadhar
- **Financial**: Monthly rent, advance paid, payment history
- **Preferences**: Food preferences (Vegetarian, Non-Veg, Vegan, Jain)
- **Accommodation**: Room assignment with details

### 5. **Vehicle Tracking**
- Store vehicle information:
  - Vehicle type (Car, Bike, Scooter, etc.)
  - Registration number
  - Model and color
  - Registration expiry date
- Optional feature - add only if tenant has vehicle

### 6. **Dashboard**
- Quick overview of metrics:
  - Total active tenants
  - Available rooms count
  - Monthly rent potential
  - Advance collected
- Recent tenants list
- Quick statistics

## Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **Local Database**: Hive (NoSQL)
- **JSON Serialization**: json_serializable
- **UI**: Material Design 3
- **Additional**: UUID for unique IDs, Intl for dates

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── tenant_model.dart       # Data models (Tenant, Room, Payment)
├── services/
│   └── database_service.dart   # Database operations
├── providers/
│   └── tenant_provider.dart    # State management
└── screens/
    ├── dashboard_screen.dart   # Dashboard overview
    ├── tenants_list_screen.dart # Tenant listings
    ├── tenant_detail_screen.dart # Tenant details & payments
    ├── add_tenant_screen.dart  # Add new tenant
    └── room_management_screen.dart # Room management
```

## Setup & Installation

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK
- Android Studio/Xcode for emulators
- VSCode or Android Studio IDE

### Steps

1. **Clone the repository**
   ```bash
   cd ~/Documents/project/pg-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Build generated files** (for JSON serialization)
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   # For Android
   flutter run -d android
   
   # For Web
   flutter run -d chrome
   
   # For iOS (macOS only)
   flutter run -d ios
   ```

## Database Models

### Tenant
- id (unique identifier)
- name, email, phone, address
- aadharNumber
- roomId
- checkInDate, checkOutDate
- payments (list)
- advanceAmount, monthlyRent
- foodPreference (enum)
- vehicleDetail (optional)
- isActive (boolean)

### Room
- id (unique identifier)
- roomNumber
- capacity
- monthlyRent
- currentTenantId
- description
- amenities (list)
- isAvailable

### PaymentRecord
- id (unique identifier)
- tenantId
- amount
- paymentType (rent, advance, security_deposit, other)
- paymentDate
- notes

### VehicleDetail
- type (Car, Bike, Scooter, etc.)
- registrationNumber
- model
- color
- registrationExpiry

## Usage Guide

### Adding a Tenant
1. Tap the "+" button on Tenants tab
2. Fill in basic information (name, email, phone, address, aadhar)
3. Select room from available list
4. Choose food preference
5. Enter monthly rent and advance amount
6. Optionally add vehicle details
7. Tap "Add Tenant"

### Managing Payments
1. Go to Tenants tab and select a tenant
2. Go to "Payment" tab
3. Tap "Add Rent" or "Add Advance" button
4. Enter amount and optional notes
5. Payment is recorded immediately

### Managing Rooms
1. Go to Rooms tab
2. Tap "+" to add a new room
3. Enter room details (number, capacity, rent)
4. View room status (Available/Occupied)

### Removing a Tenant
1. Select tenant from list
2. Tap delete icon
3. Confirm removal
4. Tenant marked as inactive

## Future Enhancements

### Planned Features
1. **Reports & Analytics**
   - Monthly revenue reports
   - Payment due alerts
   - Occupancy statistics

2. **Notifications**
   - Rent reminder notifications
   - Lease expiry alerts
   - Payment confirmations

3. **Data Export**
   - Export to PDF
   - Excel export for records
   - Print capabilities

4. **Multi-property Support**
   - Manage multiple PG properties
   - Separate tenant lists per property

5. **Backup & Sync**
   - Cloud backup with Firebase
   - Multi-device sync
   - Automatic backups

6. **Advanced Features**
   - Visitor management
   - Maintenance request tracking
   - Expense management
   - Monthly billing generation
   - Food menu management
   - Complaint tracking system

7. **User Authentication**
   - Owner login
   - Separate admin/staff accounts
   - Role-based access

## Suggestions & Best Practices

### For Better Management
1. **Organize Rooms**: Use clear room numbering system
2. **Regular Backups**: Export data regularly
3. **Payment Tracking**: Record all payments immediately
4. **Vehicle Verification**: Keep vehicle registration copies
5. **Emergency Contact**: Store multiple contact numbers
6. **Lease Terms**: Document all payment terms clearly
7. **Food Menu**: Maintain monthly food preferences list

### App Tips
- Use the Dashboard to monitor occupancy and revenue
- Review payment history regularly to identify outstanding dues
- Keep room details updated for quick tenant assignment
- Maintain accurate vehicle information for parking management

## Troubleshooting

### Common Issues

1. **App crashes on startup**
   - Run `flutter clean`
   - Run `flutter pub get` again
   - Rebuild with `flutter run`

2. **Database not persisting**
   - Check Hive initialization in main.dart
   - Ensure proper permissions on device

3. **Build fails**
   - Run `flutter pub run build_runner clean`
   - Then `flutter pub run build_runner build`

## Contributing

To contribute improvements:
1. Create feature branch
2. Make changes
3. Test thoroughly
4. Submit pull request

## Support

For issues or feature requests, please create an issue in the repository.

## License

This project is open source and available under the MIT License.

---

**Note**: This app uses local Hive database. For production use with multiple devices, consider implementing cloud synchronization using Firebase or similar services.
