class Recipe {
  final String id;
  final String title;
  final String image;
  final String category;
  final String diet;
  final List<String> ingredients;
  final List<String> steps;
  Recipe(
      {required this.id,
      required this.title,
      required this.image,
      required this.category,
      required this.diet,
      required this.ingredients,
      required this.steps});
  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
      id: j['id'],
      title: j['title'],
      image: j['image'],
      category: j['category'],
      diet: j['diet'],
      ingredients: List<String>.from(j['ingredients']),
      steps: List<String>.from(j['steps']));
}
