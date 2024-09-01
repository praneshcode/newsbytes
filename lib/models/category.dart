class Category {
  String category;
  bool isSelected;

  Category({
    required this.category,
    required this.isSelected,
  });

  static List<Category> get getCategories {
    List<Category> list = [];
    list.add(Category(category: 'Business', isSelected: true));
    list.add(Category(category: 'Technology', isSelected: false));
    list.add(Category(category: 'Entertainment', isSelected: false));
    list.add(Category(category: 'Sports', isSelected: false));
    list.add(Category(category: 'Science', isSelected: false));
    list.add(Category(category: 'Health', isSelected: false));

    return list;
  }
}
