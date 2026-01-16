import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tenant_model.dart';
import '../providers/tenant_provider.dart';
import '../services/database_service.dart';

class RoomManagementScreen extends StatefulWidget {
  const RoomManagementScreen({Key? key}) : super(key: key);

  @override
  State<RoomManagementScreen> createState() => _RoomManagementScreenState();
}

class _RoomManagementScreenState extends State<RoomManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController roomNumberController;
  late TextEditingController rentController;
  late TextEditingController descriptionController;
  int selectedCapacity = 1;

  @override
  void initState() {
    super.initState();
    roomNumberController = TextEditingController();
    rentController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    roomNumberController.dispose();
    rentController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _showAddRoomDialog() {
    roomNumberController.clear();
    rentController.clear();
    descriptionController.clear();
    selectedCapacity = 1;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Room'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: roomNumberController,
                  decoration: InputDecoration(
                    labelText: 'Room Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Room number required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Sharing Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedCapacity,
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('Single Sharing')),
                          DropdownMenuItem(value: 2, child: Text('2 Sharing')),
                          DropdownMenuItem(value: 3, child: Text('3 Sharing')),
                        ],
                        onChanged: (val) {
                          setState(() {
                            selectedCapacity = val ?? 1;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: rentController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Monthly Rent',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Rent required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final room = Room(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  roomNumber: roomNumberController.text,
                    capacity: selectedCapacity,
                  monthlyRent: double.parse(rentController.text),
                  description: descriptionController.text,
                  isAvailable: true,
                );

                await context.read<TenantProvider>().addRoom(room);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Room added successfully')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Management', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Consumer<TenantProvider>(
        builder: (context, provider, _) {
          final rooms = provider.rooms;

          if (rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.door_sliding,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No rooms added yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
            ),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Room ${room.roomNumber}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: room.isAvailable
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              room.isAvailable ? 'Available' : 'Occupied',
                              style: TextStyle(
                                fontSize: 12,
                                color: room.isAvailable
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sharing: ${_sharingLabel(room.capacity)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${room.monthlyRent}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab-rooms',
        backgroundColor: Colors.blue.shade700,
        onPressed: _showAddRoomDialog,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  String _sharingLabel(int capacity) {
    switch (capacity) {
      case 1:
        return 'Single Sharing';
      case 2:
        return '2 Sharing';
      case 3:
        return '3 Sharing';
      default:
        return '${capacity} Sharing';
    }
  }
}
