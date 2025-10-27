import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/app_state.dart';
import '../models/recipe.dart';
import '../widgets/gradient_button.dart';

class RecipeDetail extends StatelessWidget {
  const RecipeDetail({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final Recipe r = app.all.firstWhere((e) => e.id == id);
    return Scaffold(
      appBar: AppBar(title: Text(r.title)),
      body: ListView(children: [
        Hero(
            tag: r.id,
            child: Image.asset(r.image, height: 240, fit: BoxFit.cover)),
        Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Ingredients",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...r.ingredients.map((e) => Row(children: [
                    const Icon(Icons.check_circle_outline, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e))
                  ])),
              const SizedBox(height: 16),
              Text("Steps", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...r.steps.asMap().entries.map((e) => ListTile(
                  leading: CircleAvatar(child: Text("${e.key + 1}")),
                  title: Text(e.value))),
              const SizedBox(height: 80),
            ])),
      ]),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Row(children: [
            Expanded(
                child: ElevatedButton.icon(
              onPressed: () => app.toggleFavorite(r.id),
              icon: Icon(app.favorites.contains(r.id)
                  ? Icons.bookmark
                  : Icons.bookmark_outline),
              label: Text(app.favorites.contains(r.id) ? "Saved" : "Save"),
            )),
            const SizedBox(width: 12),
            Expanded(
                child: GradientButton(
                    label: "Add to Planner",
                    onPressed: () async {
                      final day = await _pickDay(context);
                      if (day != null) {
                        app.addToPlanner(day, r.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.white,
                          content: Row(children: [
                            Lottie.asset('assets/animations/checkmark.json',
                                width: 44, height: 44, repeat: false),
                            const SizedBox(width: 8),
                            const Text("Added to planner!",
                                style: TextStyle(color: Colors.black)),
                          ]),
                        ));
                      }
                    })),
          ])),
    );
  }

  Future<String?> _pickDay(BuildContext context) async {
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return showModalBottomSheet<String>(
        context: context,
        builder: (_) => ListView(
            children: days
                .map((d) =>
                    ListTile(title: Text(d), onTap: () => Navigator.pop(_, d)))
                .toList()));
  }
}
