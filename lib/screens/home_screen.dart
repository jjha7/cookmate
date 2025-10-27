import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/app_state.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String q = "";
  String? filterCat;
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final results = app.all.where((r) {
      final okQ = q.isEmpty || r.title.toLowerCase().contains(q.toLowerCase());
      final okC = filterCat == null || r.category == filterCat;
      return okQ && okC;
    }).toList();
    return Scaffold(
      appBar: AppBar(title: const Text("Recipes"), actions: const [
        Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.menu))
      ]),
      body: Column(children: [
        const SizedBox(height: 8),
        Lottie.asset('assets/animations/healthy_food.json',
            width: 160, height: 160),
        Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: "Search recipes...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)))),
              onChanged: (v) => setState(() => q = v),
            )),
        _Categories(
            selected: filterCat ?? "All",
            onSelect: (c) => setState(() => filterCat = c == "All" ? null : c)),
        const SizedBox(height: 6),
        Expanded(
            child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .78,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12),
          itemCount: results.length,
          itemBuilder: (_, i) {
            final r = results[i];
            return RecipeCard(
                r: r,
                onTap: () =>
                    Navigator.pushNamed(context, "/detail", arguments: r.id),
                onFav: () => app.toggleFavorite(r.id),
                isFavorite: app.favorites.contains(r.id));
          },
        )),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, "/coming"),
            icon: const Icon(Icons.fastfood),
            label: const Text("More recipes — coming soon"),
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16))),
          ),
        ),
      ]),
      bottomNavigationBar: _NavBar(currentIndex: 0),
    );
  }
}

class _Categories extends StatelessWidget {
  final String selected;
  final void Function(String) onSelect;
  const _Categories({required this.selected, required this.onSelect});
  @override
  Widget build(BuildContext context) {
    final cats = ["All", "Breakfast", "Lunch", "Dinner", "Dessert"];
    return SizedBox(
        height: 44,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (_, i) {
              final c = cats[i];
              final sel = c == selected;
              return ChoiceChip(
                  label: Text(c),
                  selected: sel,
                  onSelected: (_) => onSelect(c));
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemCount: cats.length));
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
        if (i == 0) return;
        if (i == 1) Navigator.pushReplacementNamed(context, "/favorites");
        if (i == 2) Navigator.pushReplacementNamed(context, "/planner");
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
