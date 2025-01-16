part of 'category_bloc.dart';

@immutable
class CategoryState {
  final List<String> categories;
  final Map<String, bool> selectedCategories;

  const CategoryState({
    required this.categories,
    required this.selectedCategories,
  });

  CategoryState copyWith({
    List<String>? categories,
    Map<String, bool>? selectedCategories,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }
}
