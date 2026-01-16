<!-- 
Run this command to generate JSON serialization code:
flutter pub run build_runner build

This will generate the .g.dart files needed for JSON serialization.
-->

# Android Configuration

## AndroidManifest.xml Changes (android/app/src/main/AndroidManifest.xml)

Add these permissions if needed:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

## iOS Configuration

For iOS 16+, add the following to ios/Podfile:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_PHOTOS=1',
      ]
    end
  end
end
```

## Web Configuration

For web deployment, ensure web/index.html has proper viewport settings:

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

---

# First Time Setup

## 1. Create Initial Rooms

When you first open the app, go to the Rooms tab and create rooms:
- Room 101, Capacity: 1, Rent: 5000
- Room 102, Capacity: 2, Rent: 8000
- Room 201, Capacity: 1, Rent: 5000
- etc.

## 2. Add Test Tenant (Optional)

After creating rooms, add a test tenant:
- Name: Test User
- Email: test@example.com
- Phone: 9876543210
- Address: Test Address
- Aadhar: 123456789012
- Room: 101
- Food: Vegetarian
- Rent: 5000
- Advance: 10000

## 3. Test Payment Recording

Add a payment to verify payment tracking works:
- Type: Advance
- Amount: 10000
- Notes: Initial advance

---

# Troubleshooting

## Database Issues

If database is corrupted:
1. Uninstall app
2. Reinstall fresh
3. Run: `flutter clean && flutter pub get`

## Build Issues

If build fails:
```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build
flutter run
```

## Hot Reload Issues

If hot reload doesn't work:
1. Stop the app with Ctrl+C
2. Run: `flutter run`

---

# Performance Tips

1. **Limit displayed tenants**: For >500 tenants, implement pagination
2. **Cache data**: Provider already caches data efficiently
3. **Lazy loading**: Future builders load data on demand
4. **Database indexing**: Hive automatically indexes on keys

---

# Data Privacy & Security

⚠️ **Important**: This is a local database app. 

- All data stored locally on device
- No data sent to servers
- For production use:
  - Implement user authentication
  - Add data encryption
  - Set up cloud backup
  - Implement access control

---

# Backup & Recovery

## Manual Backup Steps

1. For Android: Check `/data/data/com.example.pg_management_app/`
2. For iOS: Use Xcode to access app container
3. Recommended: Export data regularly to external storage

## Recommended Future Implementation

- Implement backup to Google Drive / iCloud
- Add scheduled automatic backups
- Implement version control for data

---

