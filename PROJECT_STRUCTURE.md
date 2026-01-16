<!-- Project Structure Documentation -->

# Project File Structure

```
pg-app/
├── android/                          # Android platform files
│   ├── app/
│   ├── gradle/
│   └── settings.gradle
│
├── ios/                              # iOS platform files
│   ├── Runner/
│   ├── Runner.xcworkspace/
│   └── Podfile
│
├── web/                              # Web platform files
│   ├── index.html
│   ├── manifest.json
│   └── favicon.png
│
├── lib/                              # Main app source code
│   ├── main.dart                     # App entry point
│   │
│   ├── models/                       # Data models
│   │   ├── tenant_model.dart         # Tenant, Room, Payment, Vehicle models
│   │   └── hive_adapters.dart        # Hive adapters (optional)
│   │
│   ├── services/                     # Business logic
│   │   └── database_service.dart     # Hive database operations
│   │
│   ├── providers/                    # State management
│   │   └── tenant_provider.dart      # ChangeNotifier for app state
│   │
│   ├── screens/                      # UI Screens
│   │   ├── dashboard_screen.dart     # Dashboard with metrics
│   │   ├── tenants_list_screen.dart  # List of all tenants
│   │   ├── tenant_detail_screen.dart # Detailed tenant view
│   │   ├── add_tenant_screen.dart    # Form to add tenant
│   │   └── room_management_screen.dart # Room management
│   │
│   ├── utils/                        # Utility files
│   │   └── sample_data.dart          # Sample data for testing
│   │
│   └── assets/                       # App assets
│       ├── images/
│       ├── icons/
│       └── fonts/
│
├── test/                             # Unit and widget tests
│   └── widget_test.dart
│
├── pubspec.yaml                      # Dependencies configuration
├── pubspec.lock                      # Locked dependency versions
├── analysis_options.yaml             # Lint analysis rules
│
├── README.md                         # Project overview
├── QUICKSTART.md                     # Quick start guide
├── FEATURES.md                       # Feature checklist
├── SETUP.md                          # Detailed setup
└── API_DOCUMENTATION.md              # Technical documentation

```

## File Descriptions

### Core Files

#### `main.dart` (83 lines)
- App initialization with MaterialApp
- Main screen with bottom navigation
- Database initialization
- Provider setup

#### Models (`models/`)

**`tenant_model.dart`** (165 lines)
- `Tenant` class - Main user entity
- `PaymentRecord` class - Financial transactions
- `Room` class - Property rooms
- `VehicleDetail` class - Optional vehicle info
- Enums: `FoodPreference`, `PaymentType`

**`hive_adapters.dart`** (12 lines)
- Hive type adapters for serialization

### Services (`services/`)

**`database_service.dart`** (87 lines)
- Initializes Hive database
- CRUD operations for Tenant, Room, Payment
- Query methods for filtering
- Data persistence logic

### State Management (`providers/`)

**`tenant_provider.dart`** (105 lines)
- ChangeNotifier for reactive updates
- Holds cached data
- Business logic for calculations
- Notifies UI on changes

### Screens (`screens/`)

**`dashboard_screen.dart`** (120 lines)
- Overview with key metrics
- GridView of statistics
- Recent tenants list
- Performance indicators

**`tenants_list_screen.dart`** (90 lines)
- ListView of all tenants
- Tap to view details
- FAB to add tenant
- Empty state handling

**`tenant_detail_screen.dart`** (310 lines)
- PageView with 3 tabs
- Personal information
- Payment management
- Vehicle details
- Add/manage payments

**`add_tenant_screen.dart`** (250 lines)
- Multi-section form
- Basic information section
- Room & preferences section
- Payment section
- Vehicle details section
- Form validation

**`room_management_screen.dart`** (180 lines)
- GridView of rooms
- Add room dialog
- Room status display
- Room availability toggle

### Utilities (`utils/`)

**`sample_data.dart`** (85 lines)
- Helper functions for sample data
- Test data generation
- Used for development/testing

### Configuration Files

**`pubspec.yaml`** (62 lines)
- App metadata
- Dependencies list
- Dev dependencies
- Asset declarations
- Font configuration

**`analysis_options.yaml`** (4 lines)
- Lint rules
- Code analysis settings

### Documentation Files

**`README.md`** (250+ lines)
- Complete project overview
- Setup instructions
- Feature descriptions
- Troubleshooting guide

**`QUICKSTART.md`** (280+ lines)
- 5-minute setup guide
- First-time user instructions
- Common workflows
- FAQ section

**`FEATURES.md`** (180+ lines)
- Complete feature checklist
- Implemented features marked
- Future enhancements planned
- Performance notes

**`SETUP.md`** (100+ lines)
- Detailed setup instructions
- Android/iOS configuration
- Web setup
- Build troubleshooting

**`API_DOCUMENTATION.md`** (350+ lines)
- Architecture overview
- Module breakdown
- Data flow diagrams
- API reference
- Performance optimization

---

## Code Statistics

| Component | Files | Lines | Purpose |
|-----------|-------|-------|---------|
| Models | 2 | ~180 | Data structures |
| Services | 1 | ~90 | Database ops |
| Providers | 1 | ~110 | State management |
| Screens | 5 | ~850 | UI/UX |
| Utils | 1 | ~90 | Helpers |
| Config | 2 | ~70 | Configuration |
| **Total** | **12** | **~1390** | **Core app** |

---

## Dependency Tree

```
flutter
├── provider (State Management)
├── hive (Local Database)
├── hive_flutter (Hive init)
├── json_annotation (JSON)
├── uuid (Unique IDs)
├── intl (Date formatting)
├── flutter_form_builder (Forms)
└── [Other UI packages]

build_runner (Dev)
├── json_serializable
└── hive_generator
```

---

## Module Dependencies

```
main.dart
    ↓
└── providers/tenant_provider.dart
        ↓
        └── services/database_service.dart
                ↓
                └── models/tenant_model.dart

screens/ (depends on)
    ├── providers/tenant_provider.dart
    └── models/tenant_model.dart
```

---

## Database Persistence

```
Hive Boxes (Local Storage)
├── Box: "tenants" → List<Tenant>
├── Box: "rooms" → List<Room>
└── Box: "payments" → List<PaymentRecord>
```

---

## Asset Organization

```
assets/
├── images/                  # App images (future)
├── icons/                   # Custom icons (future)
└── fonts/                   # Custom fonts (future)
```

Currently using Material Design icons from Flutter.

---

## File Size Reference

| File | Size | Type |
|------|------|------|
| tenant_model.dart | ~5KB | Model |
| database_service.dart | ~3KB | Service |
| tenant_provider.dart | ~4KB | Provider |
| dashboard_screen.dart | ~4KB | Screen |
| tenants_list_screen.dart | ~3KB | Screen |
| tenant_detail_screen.dart | ~10KB | Screen |
| add_tenant_screen.dart | ~8KB | Screen |
| room_management_screen.dart | ~6KB | Screen |

---

## Key Directories

### Required
- `lib/` - Dart source code
- `android/` - Android native code
- `ios/` - iOS native code
- `web/` - Web assets
- `test/` - Test files

### Generated (by build_runner)
- `.dart_tool/` - Build artifacts
- `*.g.dart` - Generated code files

### Documentation
- Root directory contains all `.md` files

---

## Next File to Add

When adding new features, create files in this structure:

```
Feature: Maintenance Tracking
├── models/maintenance_model.dart (Model)
├── screens/maintenance_screen.dart (UI)
├── services/[updated]database_service.dart (Add methods)
└── providers/[updated]tenant_provider.dart (Add state)
```

---

## Total Project Scope

- **Platform Support**: Android, iOS, Web
- **Total Lines of Code**: ~1400 (core app)
- **Documentation**: ~1500 lines
- **Dependencies**: 20+ packages
- **Supported Tenants**: 100+ per property
- **Database Storage**: Local Hive (expandable)

---

Last Updated: January 16, 2026
