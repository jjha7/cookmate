import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_state.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final items = <String,int>{};
    app.planner.forEach((_, ids){
      for (final id in ids) {
        final r = app.all.firstWhere((e)=> e.id==id);
        for (final ing in r.ingredients) { items[ing] = (items[ing] ?? 0) + 1; }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              if (items.isEmpty) return;
              final txt = items.entries.map((e) => "• ${e.key}${e.value>1 ? " x${e.value}" : ""}").join("\n");
              Share.share("🛒 Grocery List\n\n$txt");
            },
          ),
        ],
      ),
      body: items.isEmpty
        ? const Center(child: Text("No items yet. Add recipes to planner."))
        : ListView(
            padding: const EdgeInsets.all(12),
            children: items.entries.map((e)=> CheckboxListTile(
              value:false, onChanged: (_){}, title: Text(e.key), subtitle: e.value>1 ? Text("x${e.value}") : null
            )).toList(),
          ),
    );
  }
}
