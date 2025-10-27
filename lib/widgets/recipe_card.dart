import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe r;
  final VoidCallback onTap;
  final VoidCallback? onFav;
  final bool isFavorite;
  const RecipeCard({super.key, required this.r, required this.onTap, this.onFav, this.isFavorite=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        elevation: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(children: [
            Positioned.fill(child: Hero(tag: r.id, child: Image.asset(r.image, fit: BoxFit.cover))),
            Positioned(left:0,right:0,bottom:0,height:120,child: DecoratedBox(
              decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent.withValues(alpha: 0.0),
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.35),
                ],
              )),
            )),
            Positioned(left:12,right:12,bottom:52,child: Text(
              r.title,
              maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, shadows: [Shadow(blurRadius:6,color: Colors.black38)]),
            )),
            Positioned(left:12,right:12,bottom:12,child: Row(children:[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white.withValues(alpha: .85)),
                child: Text("${r.category}${r.minutes!=null ? " • ${r.minutes}m" : ""}", style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
              if (onFav != null)
                IconButton(icon: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_outline, color: Colors.white), onPressed: onFav),
            ])),
          ]),
        ),
      ),
    );
  }
}
