import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/customer_controller.dart';
import 'theme/app_theme.dart';
import 'utils/app_strings.dart';
import 'views/customer_list_screen.dart';

void main() {
  // App initialization without Firebase (for purely frontend demo)
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerController()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lawyerTheme,
        home: const CustomerListScreen(),
      ),
    );
  }
}
