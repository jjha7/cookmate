import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(children: [
        const SizedBox(height: 12),
        SwitchListTile(title: const Text("Dark Mode"), value: app.themeMode==ThemeMode.dark, onChanged: (v)=> app.setTheme(v? ThemeMode.dark : ThemeMode.light)),
        ListTile(title: const Text("Use System Theme"), trailing: const Icon(Icons.chevron_right), onTap: ()=> app.setTheme(ThemeMode.system)),
        const Divider(),
        ListTile(title: const Text("Clear Data"), subtitle: const Text("Favorites and weekly planner"), trailing: const Icon(Icons.delete_outline), onTap: ()=> app.clearAll()),
        const SizedBox(height: 24), const Center(child: Text("CookMate • Custom Build")), const SizedBox(height: 24),
      ]),
      bottomNavigationBar: const _NavBar(currentIndex: 3),
    );
  }
}

class _NavBar extends StatelessWidget {
  final int currentIndex; const _NavBar({required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (i){
        if (i==0) Navigator.pushReplacementNamed(context, "/");
        if (i==1) Navigator.pushReplacementNamed(context, "/favorites");
        if (i==2) Navigator.pushReplacementNamed(context, "/planner");
        if (i==3) return;
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: "Home"),
        NavigationDestination(icon: Icon(Icons.bookmark_outline), selectedIcon: Icon(Icons.bookmark), label: "Favorites"),
        NavigationDestination(icon: Icon(Icons.event_note_outlined), selectedIcon: Icon(Icons.event_note), label: "Planner"),
        NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: "Settings"),
      ],
    );
  }
}
