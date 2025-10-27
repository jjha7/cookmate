import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
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

class CookMateApp extends StatelessWidget {
  final AppState state;
  const CookMateApp({super.key, required this.state});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: Consumer<AppState>(builder: (_, app, __) {
        final theme = ThemeData(
          colorSchemeSeed: const Color(0xFFFF7E5F),
          useMaterial3: true,
          brightness: app.themeMode == ThemeMode.dark
              ? Brightness.dark
              : Brightness.light,
        );
        return MaterialApp(
          title: 'CookMate',
          theme: theme,
          darkTheme: ThemeData(
              colorSchemeSeed: const Color(0xFFFF7E5F),
              useMaterial3: true,
              brightness: Brightness.dark),
          themeMode: app.themeMode,
          debugShowCheckedModeBanner: false,
          routes: {
            "/": (_) => const HomeScreen(),
            "/detail": (_) => const RecipeDetail(),
            "/favorites": (_) => const FavoritesScreen(),
            "/planner": (_) => const MealPlanner(),
            "/shopping": (_) => const ShoppingListScreen(),
            "/settings": (_) => const SettingsScreen(),
            "/coming": (_) => const ComingSoonScreen(),
          },
        );
      }),
    );
  }
}
