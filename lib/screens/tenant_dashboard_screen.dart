import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tenant_model.dart';
import '../models/user_model.dart';
import '../providers/tenant_provider.dart';
import '../providers/auth_provider.dart';

class TenantDashboardScreen extends StatelessWidget {
  const TenantDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return PopupMenuButton<void>(
                itemBuilder: (context) => [
                  PopupMenuItem<void>(
                    enabled: false,
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 8),
                        Text(authProvider.currentUser?.name ?? 'User'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<void>(
                    onTap: () {
                      authProvider.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login',
                        (route) => false,
                      );
                    },
                    child: const Text('Logout'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final currentUser = authProvider.currentUser;
          if (currentUser == null) {
            return const Center(child: Text('Not authenticated'));
          }

          return Consumer<TenantProvider>(
            builder: (context, provider, _) {
              // Find the tenant record matching the current user by email
              final tenantRecord = provider.tenants.cast<Tenant?>().firstWhere(
                (t) => t != null && t.email == currentUser.email,
                orElse: () => null,
              );

              if (tenantRecord == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No room assigned yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              final room = provider.rooms.firstWhere(
                (r) => r.id == tenantRecord.roomId,
                orElse: () => Room(
                  id: 'unknown',
                  pgId: tenantRecord.pgId,
                  roomNumber: 'Unknown',
                  capacity: 1,
                  monthlyRent: 0,
                  isAvailable: false,
                ),
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, ${currentUser.name}!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Email: ${currentUser.email}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Phone: ${currentUser.phone}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Room Information
                    const Text(
                      'Your Room Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Room Number', room.roomNumber),
                            _buildDetailRow('Sharing Type', _sharingLabel(room.capacity)),
                            _buildDetailRow('Monthly Rent', '₹${room.monthlyRent}'),
                            if (room.description != null && room.description!.isNotEmpty)
                              _buildDetailRow('Description', room.description!),
                            if (room.amenities.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              const Text(
                                'Amenities:',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: room.amenities
                                    .map((amenity) => Chip(label: Text(amenity)))
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Personal Details
                    const Text(
                      'Your Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Address', tenantRecord.address),
                            _buildDetailRow('Aadhar', tenantRecord.aadharNumber),
                            _buildDetailRow('Check-in Date',
                                tenantRecord.checkInDate.toString().split(' ')[0]),
                            _buildDetailRow('Food Preference',
                                tenantRecord.foodPreference.name.toUpperCase()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Payment Summary
                    const Text(
                      'Payment Summary',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Consumer<TenantProvider>(
                      builder: (context, provider, _) {
                        final totalAdvancePaid =
                            provider.getTotalAdvancePaid(tenantRecord.id);
                        final totalRentPaid =
                            provider.getTotalRentPaid(tenantRecord.id);

                        return Column(
                          children: [
                            _buildPaymentCard(
                              'Advance Paid',
                              '₹${totalAdvancePaid.toStringAsFixed(2)}',
                              Colors.blue,
                            ),
                            const SizedBox(height: 12),
                            _buildPaymentCard(
                              'Rent Paid',
                              '₹${totalRentPaid.toStringAsFixed(2)}',
                              Colors.green,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(String label, String amount, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
