class CategoryModel {
  final int id;
  final String name;
  final int? parentId;
  final List<CategoryModel>? subcategories;

  const CategoryModel({
    required this.id,
    required this.name,
    this.parentId,
    this.subcategories,
  });
}