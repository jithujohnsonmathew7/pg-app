import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'providers/tenant_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/owner_dashboard_screen.dart';
import 'screens/tenant_dashboard_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/tenants_list_screen.dart';
import 'screens/room_management_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Initialize database
  final databaseService = DatabaseService();
  await databaseService.initDatabase();
  
  runApp(MyApp(databaseService: databaseService));
}

class MyApp extends StatelessWidget {
  final DatabaseService databaseService;

  const MyApp({Key? key, required this.databaseService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(databaseService),
        ),
        ChangeNotifierProvider(
          create: (_) => TenantProvider(databaseService)..loadAllData(),
        ),
      ],
      child: MaterialApp(
        title: 'PG Flow',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const RootScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/owner_dashboard': (context) => const OwnerDashboardScreen(),
          '/tenant_dashboard': (context) => const TenantDashboardScreen(),
        },
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }

        // Route based on user role
        if (authProvider.isOwner()) {
          return const OwnerMainScreen();
        } else {
          return const TenantDashboardScreen();
        }
      },
    );
  }
}

class OwnerMainScreen extends StatefulWidget {
  const OwnerMainScreen({Key? key}) : super(key: key);

  @override
  State<OwnerMainScreen> createState() => _OwnerMainScreenState();
}

class _OwnerMainScreenState extends State<OwnerMainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          OwnerDashboardScreen(),
          TenantsListScreen(),
          RoomManagementScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Tenants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.door_sliding),
            label: 'Rooms',
          ),
        ],
      ),
    );
  }
}
