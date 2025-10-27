import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class MealPlanner extends StatelessWidget {
  const MealPlanner({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return Scaffold(
      appBar: AppBar(title: const Text("Meal Planner")),
      body: ListView(
          padding: const EdgeInsets.all(12),
          children: days.map((d) {
            final ids = app.planner[d] ?? [];
            return Card(
                child: ExpansionTile(title: Text(d), children: [
              if (ids.isEmpty) const ListTile(title: Text("No recipes yet.")),
              ...ids.map((id) {
                final r = app.all.firstWhere((e) => e.id == id);
                return ListTile(
                  leading: Image.asset(r.image,
                      width: 56, height: 56, fit: BoxFit.cover),
                  title: Text(r.title),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => app.removeFromPlanner(d, r.id)),
                  onTap: () =>
                      Navigator.pushNamed(context, "/detail", arguments: r.id),
                );
              })
            ]));
          }).toList()),
      bottomNavigationBar: const _NavBar(currentIndex: 2),
    );
  }
}

class _NavBar extends StatelessWidget {
  final int currentIndex;
  const _NavBar({required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (i) {
        if (i == 0) Navigator.pushReplacementNamed(context, "/");
        if (i == 1) Navigator.pushReplacementNamed(context, "/favorites");
        if (i == 2) return;
        if (i == 3) Navigator.pushReplacementNamed(context, "/settings");
      },
      destinations: const [
        NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home"),
        NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: "Favorites"),
        NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: "Planner"),
        NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Settings"),
      ],
    );
  }
}
