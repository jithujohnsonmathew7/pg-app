import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/tenant_model.dart';
import '../providers/tenant_provider.dart';

class TenantDetailScreen extends StatefulWidget {
  final Tenant tenant;

  const TenantDetailScreen({Key? key, required this.tenant}) : super(key: key);

  @override
  State<TenantDetailScreen> createState() => _TenantDetailScreenState();
}

class _TenantDetailScreenState extends State<TenantDetailScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addPayment(PaymentType type) {
    final amountController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${type.name.replaceAll('_', ' ').toUpperCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (amountController.text.isNotEmpty) {
                final payment = PaymentRecord(
                  id: const Uuid().v4(),
                  tenantId: widget.tenant.id,
                  amount: double.parse(amountController.text),
                  paymentType: type,
                  paymentDate: DateTime.now(),
                  notes: notesController.text,
                );

                await context.read<TenantProvider>().addPayment(payment);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment added successfully')),
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

  void _removeTenant() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Tenant'),
        content: const Text('Are you sure you want to remove this tenant?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedTenant =
                  widget.tenant.copyWith(isActive: false, checkOutDate: DateTime.now());
              final provider = context.read<TenantProvider>();
              await provider.updateTenant(updatedTenant);

              // Free up the room
              final room = provider.rooms.firstWhere(
                (r) => r.id == updatedTenant.roomId,
                orElse: () => Room(
                  id: updatedTenant.roomId,
                  roomNumber: '',
                  capacity: 1,
                  monthlyRent: 0,
                  isAvailable: true,
                ),
              );

              final updatedRoom = Room(
                id: room.id,
                roomNumber: room.roomNumber,
                capacity: room.capacity,
                monthlyRent: room.monthlyRent,
                currentTenantId: null,
                description: room.description,
                amenities: room.amenities,
                isAvailable: true,
              );
              await provider.updateRoom(updatedRoom);
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tenant removed successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tenant.name),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _removeTenant,
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Indicators
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton(0, 'Personal'),
                _buildTabButton(1, 'Payment'),
                _buildTabButton(2, 'Vehicle'),
              ],
            ),
          ),
          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildPersonalTab(),
                _buildPaymentTab(),
                _buildVehicleTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _currentPage == index ? Colors.blue.shade700 : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: _currentPage == index ? FontWeight.bold : FontWeight.normal,
            color: _currentPage == index ? Colors.blue.shade700 : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Basic Information', [
            _buildInfoRow('Name', widget.tenant.name),
            _buildInfoRow('Email', widget.tenant.email),
            _buildInfoRow('Phone', widget.tenant.phone),
            _buildInfoRow('Address', widget.tenant.address),
            _buildInfoRow('Aadhar', widget.tenant.aadharNumber),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Room & Preferences', [
            _buildInfoRow('Room', widget.tenant.roomId),
            _buildInfoRow('Food Preference', widget.tenant.foodPreference.name),
            _buildInfoRow('Check-in Date',
                widget.tenant.checkInDate.toString().split(' ')[0]),
            _buildInfoRow('Monthly Rent', '₹${widget.tenant.monthlyRent}'),
          ]),
        ],
      ),
    );
  }

  Widget _buildPaymentTab() {
    return FutureBuilder<List<PaymentRecord>>(
      future: context.read<TenantProvider>().getTenantPayments(widget.tenant.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final payments = snapshot.data ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<TenantProvider>(
                builder: (context, provider, _) {
                  final totalAdvance =
                      provider.getTotalAdvancePaid(widget.tenant.id);
                  final totalRent = provider.getTotalRentPaid(widget.tenant.id);

                  return Column(
                    children: [
                      _buildPaymentSummaryCard(
                        'Advance Paid',
                        '₹${totalAdvance.toStringAsFixed(2)}',
                        Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _buildPaymentSummaryCard(
                        'Rent Paid',
                        '₹${totalRent.toStringAsFixed(2)}',
                        Colors.green,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _addPayment(PaymentType.advance),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Advance'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _addPayment(PaymentType.rent),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Rent'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (payments.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No payments yet'),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: payments.length,
                  itemBuilder: (context, index) {
                    final payment = payments[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          payment.paymentType == PaymentType.rent
                              ? Icons.receipt
                              : Icons.savings,
                          color: Colors.blue.shade700,
                        ),
                        title: Text(payment.paymentType.name.toUpperCase()),
                        subtitle: Text(
                          payment.paymentDate.toString().split(' ')[0],
                        ),
                        trailing: Text(
                          '₹${payment.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVehicleTab() {
    if (widget.tenant.vehicleDetail == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text('No vehicle details added'),
          ],
        ),
      );
    }

    final vehicle = widget.tenant.vehicleDetail!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildInfoCard('Vehicle Details', [
        _buildInfoRow('Type', vehicle.type),
        _buildInfoRow('Registration', vehicle.registrationNumber),
        if (vehicle.model != null) _buildInfoRow('Model', vehicle.model!),
        if (vehicle.color != null) _buildInfoRow('Color', vehicle.color!),
      ]),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard(String label, String amount, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              amount,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
