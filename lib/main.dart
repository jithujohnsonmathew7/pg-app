import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'providers/tenant_provider.dart';
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
    return ChangeNotifierProvider(
      create: (_) => TenantProvider(databaseService)..loadAllData(),
      child: MaterialApp(
        title: 'PG Management App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          DashboardScreen(),
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
