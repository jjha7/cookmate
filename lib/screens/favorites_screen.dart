import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/recipe_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final favs = app.all.where((r)=> app.favorites.contains(r.id)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text("My Favorites")),
      body: favs.isEmpty
        ? const Center(child: Text("No favorites yet."))
        : GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .78, mainAxisSpacing: 12, crossAxisSpacing: 12),
            itemCount: favs.length,
            itemBuilder: (_, i) {
              final r = favs[i];
              return RecipeCard(r: r, onTap: ()=> Navigator.pushNamed(context, "/detail", arguments: r.id), onFav: ()=> app.toggleFavorite(r.id), isFavorite: true);
            },
          ),
      bottomNavigationBar: const _NavBar(currentIndex: 1),
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
        if (i==1) return;
        if (i==2) Navigator.pushReplacementNamed(context, "/planner");
        if (i==3) Navigator.pushReplacementNamed(context, "/settings");
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
