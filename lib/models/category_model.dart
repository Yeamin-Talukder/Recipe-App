class CategoryModel {
  final String id;
  final String name;
  final String? icon;
  final int order;

  const CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.order = 0,
  });

  factory CategoryModel.fromFirestore(String id, Map<String, dynamic> data) {
    return CategoryModel(
      id: id,
      name: data['name'] as String? ?? '',
      icon: data['icon'] as String?,
      order: data['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'icon': icon,
      'order': order,
    };
  }
}
