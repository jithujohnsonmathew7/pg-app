import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tenant_model.dart';
import '../models/user_model.dart';
import '../providers/tenant_provider.dart';
import '../providers/auth_provider.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard', style: TextStyle(color: Colors.white)),
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
      body: Consumer<TenantProvider>(
        builder: (context, provider, _) {
          final activeTenants =
              provider.tenantsForCurrentPg.where((t) => t.isActive).toList();
          final rooms = provider.roomsForCurrentPg;
          final totalRooms = rooms.length;
          final availableRooms = rooms.where((r) => r.isAvailable).length;
          final roomLookup = {
            for (final room in rooms) room.id: room.roomNumber,
          };

          double totalMonthlyRent = activeTenants.fold(
            0,
            (sum, t) => sum + t.monthlyRent,
          );

          final tenantIds = activeTenants.map((t) => t.id).toSet();
          double totalAdvanceCollected = provider.allPayments
              .where((p) =>
                  p.paymentType == PaymentType.advance &&
                  tenantIds.contains(p.tenantId))
              .fold(0, (sum, p) => sum + p.amount);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (provider.currentPgId != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Current PG: ${provider.pgs.firstWhere((pg) => pg.id == provider.currentPgId, orElse: () => PgProperty(id: provider.currentPgId!, name: provider.currentPgId!)).name}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                // Key Metrics
                GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _buildMetricCard(
                      'Active Tenants',
                      activeTenants.length.toString(),
                      Colors.blue,
                      Icons.people,
                    ),
                    _buildMetricCard(
                      'Available Rooms',
                      '$availableRooms/$totalRooms',
                      Colors.green,
                      Icons.door_sliding,
                    ),
                    _buildMetricCard(
                      'Monthly Rent',
                      '₹${totalMonthlyRent.toStringAsFixed(0)}',
                      Colors.orange,
                      Icons.currency_rupee,
                    ),
                    _buildMetricCard(
                      'Advance Collected',
                      '₹${totalAdvanceCollected.toStringAsFixed(0)}',
                      Colors.purple,
                      Icons.savings,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // PG Selector (if multiple PGs)
                if (provider.hasMultiplePgs) ...[
                  const Text(
                    'Switch PG',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: provider.currentPgId,
                    isExpanded: true,
                    items: provider.pgs
                        .map((pg) => DropdownMenuItem(
                              value: pg.id,
                              child: Text(pg.name),
                            ))
                        .toList(),
                    onChanged: (pgId) {
                      if (pgId != null) {
                        provider.setCurrentPg(pgId);
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                ],

                // Recent Tenants
                if (activeTenants.isNotEmpty) ...[
                  const Text(
                    'Recent Tenants',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activeTenants.take(5).length,
                    itemBuilder: (context, index) {
                      final tenant = activeTenants[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade700,
                            child: Text(
                              tenant.name[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(tenant.name),
                          subtitle: Text(
                              'Room: ${roomLookup[tenant.roomId] ?? tenant.roomId}'),
                          trailing: Text('₹${tenant.monthlyRent}'),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
