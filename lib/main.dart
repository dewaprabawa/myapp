import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/login_page.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/user_provider.dart';
import 'package:myapp/providers/dashboard_provider.dart';
import 'package:myapp/providers/category_provider.dart';
import 'package:myapp/providers/unit_provider.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:myapp/providers/partner_provider.dart';
import 'package:myapp/providers/purchase_order_provider.dart';
import 'package:myapp/providers/inventory_provider.dart';
import 'package:myapp/providers/stock_opname_provider.dart';
import 'package:myapp/providers/delivery_order_provider.dart';
import 'package:myapp/providers/invoice_provider.dart';
import 'package:myapp/providers/payment_provider.dart';
import 'package:myapp/providers/report_provider.dart';

import 'package:myapp/screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => UnitProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => PartnerProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseOrderProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => StockOpnameProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryOrderProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Start the auto-login check when the app starts
    Future.microtask(() {
      if (mounted) {
        context.read<AuthProvider>().tryAutoLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Inventory Management',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1C3A9A),
            ),
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1C3A9A),
              brightness: Brightness.dark,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.isInitializing) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              return authProvider.isAuthenticated
                  ? const HomeScreen()
                  : const LoginPage();
            },
          ),
        );
      },
    );
  }
}
