import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/tenant_model.dart';
import '../providers/tenant_provider.dart';

class AddTenantScreen extends StatefulWidget {
  const AddTenantScreen({Key? key}) : super(key: key);

  @override
  State<AddTenantScreen> createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends State<AddTenantScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController aadharController;
  late TextEditingController advanceController;
  late TextEditingController rentController;

  // Vehicle details
  late TextEditingController vehicleTypeController;
  late TextEditingController registrationController;
  late TextEditingController vehicleModelController;
  late TextEditingController vehicleColorController;

  String selectedRoom = '';
  FoodPreference selectedFood = FoodPreference.vegetarian;
  bool hasVehicle = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    aadharController = TextEditingController();
    advanceController = TextEditingController();
    rentController = TextEditingController();
    vehicleTypeController = TextEditingController();
    registrationController = TextEditingController();
    vehicleModelController = TextEditingController();
    vehicleColorController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    aadharController.dispose();
    advanceController.dispose();
    rentController.dispose();
    vehicleTypeController.dispose();
    registrationController.dispose();
    vehicleModelController.dispose();
    vehicleColorController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final provider = context.read<TenantProvider>();
        final room = provider.rooms.firstWhere(
          (r) => r.id == selectedRoom,
          orElse: () => throw Exception('Selected room not found'),
        );

        VehicleDetail? vehicleDetail;
        if (hasVehicle) {
          vehicleDetail = VehicleDetail(
            type: vehicleTypeController.text,
            registrationNumber: registrationController.text,
            model: vehicleModelController.text,
            color: vehicleColorController.text,
          );
        }

        final tenant = Tenant(
          id: const Uuid().v4(),
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          address: addressController.text,
          aadharNumber: aadharController.text,
          roomId: selectedRoom,
          checkInDate: selectedDate,
          advanceAmount: double.parse(advanceController.text),
          monthlyRent: double.parse(rentController.text),
          foodPreference: selectedFood,
          vehicleDetail: vehicleDetail,
          isActive: true,
        );

        await provider.addTenant(tenant);

        // Mark room as occupied
        final updatedRoom = Room(
          id: room.id,
          roomNumber: room.roomNumber,
          capacity: room.capacity,
          monthlyRent: room.monthlyRent,
          currentTenantId: tenant.id,
          description: room.description,
          amenities: room.amenities,
          isAvailable: false,
        );
        await provider.updateRoom(updatedRoom);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tenant added successfully')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Tenant', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              const Text(
                'Basic Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Email is required';
                  if (!value!.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Phone is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 2,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Address is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: aadharController,
                decoration: InputDecoration(
                  labelText: 'Aadhar Number',
                  prefixIcon: const Icon(Icons.credit_card),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Aadhar is required' : null,
              ),
              const SizedBox(height: 24),

              // Room & Food Preference Section
              const Text(
                'Room & Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Consumer<TenantProvider>(
                builder: (context, provider, _) {
                  return DropdownButtonFormField<String>(
                    value: selectedRoom.isEmpty ? null : selectedRoom,
                    decoration: InputDecoration(
                      labelText: 'Assign Room',
                      prefixIcon: const Icon(Icons.door_sliding),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: provider.rooms
                        .where((r) => r.isAvailable)
                        .map((room) => DropdownMenuItem(
                              value: room.id,
                              child: Text(room.roomNumber),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRoom = value ?? '';
                      });
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Room is required' : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<FoodPreference>(
                value: selectedFood,
                decoration: InputDecoration(
                  labelText: 'Food Preference',
                  prefixIcon: const Icon(Icons.restaurant),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: FoodPreference.values
                    .map((pref) => DropdownMenuItem(
                          value: pref,
                          child: Text(pref.name.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFood = value ?? FoodPreference.vegetarian;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Payment Information Section
              const Text(
                'Payment Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: rentController,
                decoration: InputDecoration(
                  labelText: 'Monthly Rent',
                  prefixIcon: const Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Rent is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: advanceController,
                decoration: InputDecoration(
                  labelText: 'Advance Amount',
                  prefixIcon: const Icon(Icons.savings),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Advance amount is required' : null,
              ),
              const SizedBox(height: 24),

              // Vehicle Details Section
              CheckboxListTile(
                title: const Text('Has Vehicle'),
                value: hasVehicle,
                onChanged: (value) {
                  setState(() {
                    hasVehicle = value ?? false;
                  });
                },
              ),
              if (hasVehicle) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: vehicleTypeController,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Type (Car, Bike, etc.)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) => hasVehicle && (value?.isEmpty ?? true)
                      ? 'Vehicle type is required'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: registrationController,
                  decoration: InputDecoration(
                    labelText: 'Registration Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) => hasVehicle && (value?.isEmpty ?? true)
                      ? 'Registration number is required'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: vehicleModelController,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Model',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: vehicleColorController,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Color',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add Tenant',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
