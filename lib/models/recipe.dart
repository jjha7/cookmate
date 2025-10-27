class Recipe {
  final String id;
  final String title;
  final String image;
  final String category;     // Breakfast/Lunch/Dinner/Dessert
  final String diet;         // veg / non-veg
  final List<String> tags;   // ["vegan","vegetarian","gluten-free"]
  final int? minutes;        // cook/prep time
  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.diet,
    required this.ingredients,
    required this.steps,
    this.tags = const [],
    this.minutes,
  });

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
    id: j['id'],
    title: j['title'],
    image: j['image'],
    category: j['category'],
    diet: j['diet'],
    ingredients: List<String>.from(j['ingredients']),
    steps: List<String>.from(j['steps']),
    tags: List<String>.from(j['tags'] ?? const []),
    minutes: j['minutes'],
  );
}
