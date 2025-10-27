import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_state.dart';
import '../models/recipe.dart';
import '../widgets/gradient_button.dart';

class RecipeDetail extends StatelessWidget {
  const RecipeDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final Recipe r = app.all.firstWhere((e)=> e.id == id);
    return Scaffold(
      appBar: AppBar(
        title: Text(r.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final text = StringBuffer()
                ..writeln("🍳 ${r.title}${r.minutes!=null ? " (${r.minutes} min)" : ""}")
                ..writeln("\nIngredients:")
                ..writeln(r.ingredients.map((e) => "• $e").join("\n"))
                ..writeln("\nSteps:")
                ..writeln(r.steps.asMap().entries.map((e) => "${e.key+1}. ${e.value}").join("\n"));
              Share.share(text.toString());
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Hero(tag: r.id, child: Image.asset(r.image, height: 260, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                if (r.minutes!=null) Chip(label: Text("${r.minutes} min")),
                const SizedBox(width: 6),
                ...r.tags.map((t)=> Padding(padding: const EdgeInsets.only(right:6), child: Chip(label: Text(t)))),
              ]),
              const SizedBox(height: 4),
              Text("Ingredients", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...r.ingredients.map((e)=> Row(children: [
                const Icon(Icons.check_circle_outline, size: 18), const SizedBox(width: 8), Expanded(child: Text(e)),
              ])),
              const SizedBox(height: 16),
              Text("Steps", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...r.steps.asMap().entries.map((e)=> ListTile(leading: CircleAvatar(child: Text("${e.key+1}")), title: Text(e.value))),
              const SizedBox(height: 84),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Row(children: [
          Expanded(child: ElevatedButton.icon(
            onPressed: ()=> app.toggleFavorite(r.id),
            icon: Icon(app.favorites.contains(r.id) ? Icons.bookmark : Icons.bookmark_outline),
            label: Text(app.favorites.contains(r.id) ? "Saved" : "Save"),
          )),
          const SizedBox(width: 12),
          Expanded(child: GradientButton(label: "Add to Planner", onPressed: () async {
            final day = await _pickDay(context);
            if (day != null) {
              app.addToPlanner(day, r.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.white,
                content: Row(children: [
                  Lottie.asset('assets/animations/checkmark.json', width: 44, height: 44, repeat: false),
                  const SizedBox(width: 8), const Text("Added to planner!", style: TextStyle(color: Colors.black)),
                ]),
              ));
            }
          })),
          const SizedBox(width: 12),
          Expanded(child: OutlinedButton.icon(
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text("Shop ingredients"),
            onPressed: () => _shopIngredients(context, r.ingredients),
          )),
        ]),
      ),
    );
  }

  Future<String?> _pickDay(BuildContext context) async {
    final days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
    return showModalBottomSheet<String>(
      context: context,
      builder: (_) => ListView(children: days.map((d)=> ListTile(title: Text(d), onTap: ()=> Navigator.pop(_, d))).toList()),
    );
  }

  Future<void> _shopIngredients(BuildContext context, List<String> ingredients) async {
    final q = Uri.encodeComponent(ingredients.join(', '));
    final walmart = Uri.parse("https://www.walmart.com/search?q=$q");
    final amazon  = Uri.parse("https://www.amazon.com/s?k=$q");
    // open chooser in bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const ListTile(title: Text("Buy ingredients online")),
          ListTile(
            leading: const Icon(Icons.store_mall_directory),
            title: const Text("Open in Walmart"),
            onTap: () => launchUrl(walmart, mode: LaunchMode.externalApplication),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart_checkout),
            title: const Text("Open in Amazon"),
            onTap: () => launchUrl(amazon, mode: LaunchMode.externalApplication),
          ),
        ]),
      ),
    );
  }
}
