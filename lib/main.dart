import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:market_list/routes/market_list_routes.dart';
import 'package:market_list/screens/market_list_home.dart';
import 'package:market_list/screens/market_login_screen.dart';
import 'package:market_list/screens/market_register_item.dart';
import 'package:market_list/screens/market_register_screen.dart';
import 'package:market_list/screens/market_selected_items.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainFile());
}

class MainFile extends StatelessWidget {
  const MainFile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        MarketListRoutes.MARKET_LIST_LOGIN: (ctx) => const MarketListHome(),
        MarketListRoutes.MARKET_LIST_REGISTER_USER: (ctx) => const MarketRegisterScreen(),
        MarketListRoutes.MARKET_LIST_REGISTER_ITEM: (ctx) =>
            const MarketRegisterItem(),
        MarketListRoutes.MARKET_LIST_SELECTED_ITEM: (ctx) =>
            const MarketSelectedItems(),
        MarketListRoutes.MARKET_LIST_HOME: (ctx) => const MarketListHome()
      },
    );
  }
}
