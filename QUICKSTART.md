# Quick Start Guide - PG Management App

## 🚀 Get Started in 5 Minutes

### Step 1: Install Flutter
```bash
# Download from flutter.dev
# Extract and add to PATH
flutter --version
```

### Step 2: Setup Project
```bash
cd ~/Documents/project/pg-app
flutter pub get
```

### Step 3: Generate Code
```bash
flutter pub run build_runner build
```

### Step 4: Run App
```bash
flutter run
```

---

## 📱 First-Time User Guide

### Initial Setup

1. **Open App** → You'll see the Dashboard

2. **Create Rooms** (Go to Rooms Tab)
   - Tap the "+" button
   - Enter: Room 101, Capacity 1, Rent 5000
   - Create at least 3-4 rooms
   - Repeat for rooms 102, 201, etc.

3. **Add Your First Tenant** (Go to Tenants Tab)
   - Tap the "+" button
   - Fill in details:
     - Name: Your tenant's name
     - Email: tenant@example.com
     - Phone: 10-digit number
     - Address: Full address
     - Aadhar: 12-digit number
   - Select a room from the list
   - Choose food preference
   - Enter monthly rent
   - Enter advance amount
   - Optionally add vehicle details
   - Tap "Add Tenant"

4. **Record Payment** (Tenant Detail Screen)
   - Tap on tenant from list
   - Go to "Payment" tab
   - Tap "Add Advance" or "Add Rent"
   - Enter amount and save

---

## 🎯 Key Features Quick Reference

### Dashboard Tab
Shows at a glance:
- Total active tenants
- Available rooms count
- Monthly rent potential
- Total advance collected
- List of recent tenants

### Tenants Tab
- View all active tenants
- Tap any tenant to see full details
- See personal info, payments, vehicle details
- Add, edit, or remove tenants
- Track payment history

### Rooms Tab
- View all property rooms
- See room status (Available/Occupied)
- Add new rooms
- Track capacity and rent per room

---

## 💰 Payment Tracking

### Adding Payments

**For Advance Payment:**
1. Go to Tenant → Payment tab
2. Tap "Add Advance"
3. Enter amount (e.g., 20000)
4. Add notes if needed
5. Save

**For Monthly Rent:**
1. Go to Tenant → Payment tab
2. Tap "Add Rent"
3. Enter amount (e.g., 5000)
4. Add notes (e.g., "January rent")
5. Save

### Viewing Payment Summary
- Each tenant shows total advance paid
- Each tenant shows total rent paid
- View payment history with dates
- Click payment to see details

---

## 📋 Tenant Management Workflow

### Adding a New Tenant
```
Tenants Tab → "+" → Fill Form → Select Room 
→ Choose Food Preference → Add Vehicle (if any) 
→ Enter Payment Info → Submit
```

### Viewing Tenant Details
```
Tenants Tab → Click Tenant → View Personal/Payment/Vehicle Info
```

### Recording Tenant Payment
```
Tenant Detail → Payment Tab → Add Payment → Enter Amount → Save
```

### Removing Tenant
```
Tenant Detail → Menu (⋮) → Delete → Confirm
```

---

## 🏠 Room Management Workflow

### Adding a Room
```
Rooms Tab → "+" → Enter Room Details 
→ Set Rent → Save
```

### Room Information Stored
- Room number (101, 102, etc.)
- Capacity (1, 2, 3, etc.)
- Monthly rent
- Description (optional)
- Current occupant
- Availability status

---

## 👤 Tenant Information Fields

### Basic Details
- Full Name
- Email Address
- Phone Number (10 digits)
- Residential Address
- Aadhar Number (12 digits)

### Financial Info
- Monthly Rent
- Advance Amount
- Payment History

### Living Details
- Assigned Room
- Check-in Date
- Food Preference (Veg/Non-Veg/Vegan/Jain)

### Vehicle Details (Optional)
- Vehicle Type
- Registration Number
- Model
- Color

---

## 🚗 Vehicle Information

### When to Add Vehicle Details
- If tenant has motorcycle, car, scooter, etc.
- Use toggle "Has Vehicle" in add tenant form
- Fields are auto-validated if toggle is ON

### Vehicle Details
- **Type**: Car, Bike, Scooter, Auto, etc.
- **Registration Number**: License plate number
- **Model**: Vehicle model name (optional)
- **Color**: Vehicle color (optional)

---

## 🍽️ Food Preferences

Choose one for each tenant:
- **Vegetarian**: Veg only
- **Non-Vegetarian**: Veg + Meat
- **Vegan**: Plant-based only
- **Jain**: Jain dietary restrictions

This helps with meal planning and dietary management.

---

## 📊 Dashboard Metrics Explained

### Active Tenants
Number of tenants currently living in the property

### Available Rooms
Shows "X / Total" (e.g., "2 / 5" means 2 rooms empty out of 5)

### Monthly Rent
Potential monthly income if all rooms occupied (sum of assigned rent)

### Advance Collected
Total advance deposits received from all tenants

---

## ⚙️ Customization Tips

### Change Room Types
- Use room descriptions for details
- Update rent rates as needed
- Mark rooms as available when tenant leaves

### Track Multiple Properties
Future version will support multiple properties. For now:
- Manage one property per installation
- Can reinstall app for different property

### Backup Data
⚠️ **Important**: Backup your data regularly
- Data stored locally on device
- Implement cloud backup in future versions
- Export data for safety

---

## ❌ Common Issues & Solutions

### Issue: App crashes on startup
**Solution**: 
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Can't add tenant (Room list empty)
**Solution**: Create rooms first in Rooms tab before adding tenants

### Issue: Payment not showing
**Solution**: Refresh the app by navigating away and back

### Issue: Deleted data can't be recovered
**Solution**: Data deletes permanently (soft delete on checkout)

---

## 📞 Data to Keep Handy

For each tenant, collect:
- [ ] Full name and email
- [ ] Phone number
- [ ] Residential address
- [ ] Aadhar number
- [ ] Monthly rent amount
- [ ] Advance amount
- [ ] Food preference
- [ ] Vehicle details (if applicable)

---

## 🔐 Data Security Notes

- All data stored locally on device
- No cloud sync currently
- No backup automatically
- Recommended: Export regularly
- Future: Cloud backup feature

---

## 📈 Future Enhancements Coming Soon

- [ ] Cloud backup & restore
- [ ] Monthly reports & analytics
- [ ] Payment reminders
- [ ] Expense tracking
- [ ] Multiple property support
- [ ] SMS notifications
- [ ] PDF report generation
- [ ] Visitor management

---

## 📞 Support

If you face issues:

1. **Check Setup**: Verify Flutter installation
   ```bash
   flutter doctor
   ```

2. **Check Dependencies**: Ensure all are installed
   ```bash
   flutter pub get
   ```

3. **Rebuild**: Clean and rebuild
   ```bash
   flutter clean
   flutter run
   ```

4. **Check Logs**: Look for error messages in console

---

## 🎓 Pro Tips

1. **Organize Room Numbers**: Use floor numbers (101 = 1st floor room 1)
2. **Record All Payments**: Track advance and rent separately
3. **Use Notes**: Add payment notes for reference (e.g., "Late payment")
4. **Regular Review**: Check dashboard weekly for occupancy
5. **Backup Often**: Export data monthly
6. **Plan Ahead**: Add empty rooms in advance

---

## Next Steps

1. ✅ Install Flutter
2. ✅ Set up project
3. ✅ Create 3-4 sample rooms
4. ✅ Add first tenant
5. ✅ Record a payment
6. ✅ Explore all tabs
7. ✅ Customize for your property
8. ✅ Add more tenants/payments

---

**You're all set! Start managing your PG today.** 🎉

For detailed documentation, see:
- `README.md` - Full project overview
- `FEATURES.md` - Complete feature list
- `SETUP.md` - Detailed setup guide
- `API_DOCUMENTATION.md` - Technical documentation

---

Last Updated: January 16, 2026
