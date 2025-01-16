import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'category_event.dart';
part 'category_state.dart';

/// CategoryBloc manages the state and events related to task categories.
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final Box<String> categoryBox;

  /// Constructor initializes the bloc with the initial state and sets up event handlers.
  CategoryBloc(this.categoryBox)
      : super(const CategoryState(categories: [], selectedCategories: {})) {
    // Register event handlers
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<SelectCategoryEvent>(_onSelectCategory);

    // Trigger the initial load of categories
    add(LoadCategoriesEvent());
  }

  /// Handles the loading of categories from the Hive box.
  void _onLoadCategories(
      LoadCategoriesEvent event, Emitter<CategoryState> emit) {
    final categories = categoryBox.values.toList();
    final selectedCategories = {
      for (var category in categories) category: true,
    };
    emit(state.copyWith(
      categories: categories,
      selectedCategories: selectedCategories,
    ));
  }

  /// Handles adding a new category.
  void _onAddCategory(AddCategoryEvent event, Emitter<CategoryState> emit) {
    if (!state.categories.contains(event.category)) {
      final updatedCategories = List<String>.from(state.categories)
        ..add(event.category);
      final updatedSelectedCategories = {
        ...state.selectedCategories,
        event.category: true,
      };

      // Save the new category to Hive
      categoryBox.add(event.category);

      emit(state.copyWith(
        categories: updatedCategories,
        selectedCategories: updatedSelectedCategories,
      ));
    }
  }

  /// Handles deleting an existing category.
  void _onDeleteCategory(
      DeleteCategoryEvent event, Emitter<CategoryState> emit) {
    final updatedCategories = state.categories
        .where((category) => category != event.category)
        .toList();
    final updatedSelectedCategories =
        Map<String, bool>.from(state.selectedCategories)
          ..remove(event.category);

    // Find the index of the category to delete
    final index = state.categories.indexOf(event.category);
    if (index != -1) {
      categoryBox.deleteAt(index);
    }

    emit(state.copyWith(
      categories: updatedCategories,
      selectedCategories: updatedSelectedCategories,
    ));
  }

  /// Handles selecting or deselecting a category for filtering.
  void _onSelectCategory(
      SelectCategoryEvent event, Emitter<CategoryState> emit) {
    final updatedSelectedCategories = {
      ...state.selectedCategories,
      event.category: !(state.selectedCategories[event.category] ?? false),
    };
    emit(state.copyWith(selectedCategories: updatedSelectedCategories));
  }
}
