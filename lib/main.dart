import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/app_state.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/recipe_detail.dart';
import 'screens/favorites_screen.dart';
import 'screens/meal_planner.dart';
import 'screens/shopping_list.dart';
import 'screens/settings_screen.dart';
import 'screens/coming_soon.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  state.init().then((_) => runApp(CookMateApp(state: state)));
}

ThemeData themed(Brightness b) => ThemeData(
  useMaterial3: true,
  brightness: b,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF7E5F), brightness: b),
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: const AppBarTheme(centerTitle: false),
);

class CookMateApp extends StatelessWidget {
  final AppState state;
  const CookMateApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: Consumer<AppState>(builder: (_, app, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CookMate',
          theme: themed(Brightness.light),
          darkTheme: themed(Brightness.dark),
          themeMode: app.themeMode,
          routes: {
            "/splash": (_) => const SplashScreen(),
            "/": (_) => const HomeScreen(),
            "/detail": (_) => const RecipeDetail(),
            "/favorites": (_) => const FavoritesScreen(),
            "/planner": (_) => const MealPlanner(),
            "/shopping": (_) => const ShoppingListScreen(),
            "/settings": (_) => const SettingsScreen(),
            "/coming": (_) => const ComingSoonScreen(),
          },
          initialRoute: "/splash",
        );
      }),
    );
  }
}
