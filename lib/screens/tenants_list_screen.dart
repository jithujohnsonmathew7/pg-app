import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tenant_model.dart';
import '../providers/tenant_provider.dart';
import 'add_tenant_screen.dart';
import 'tenant_detail_screen.dart';

class TenantsListScreen extends StatefulWidget {
  const TenantsListScreen({Key? key}) : super(key: key);

  @override
  State<TenantsListScreen> createState() => _TenantsListScreenState();
}

class _TenantsListScreenState extends State<TenantsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TenantProvider>().loadAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PG Management', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Consumer<TenantProvider>(
        builder: (context, provider, _) {
          final tenants = provider.tenants.where((t) => t.isActive).toList();

          if (tenants.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No tenants yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddTenantScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                    ),
                    child: const Text('Add First Tenant', style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: tenants.length,
            itemBuilder: (context, index) {
              final tenant = tenants[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade700,
                    child: Text(
                      tenant.name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    tenant.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Room: ${tenant.roomId}'),
                      Text('Phone: ${tenant.phone}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TenantDetailScreen(tenant: tenant),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TenantDetailScreen(tenant: tenant),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab-tenants',
        backgroundColor: Colors.blue.shade700,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddTenantScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
