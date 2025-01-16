part of 'category_bloc.dart';

abstract class CategoryEvent {}

class LoadCategoriesEvent extends CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final String category;
  AddCategoryEvent(this.category);
}

class DeleteCategoryEvent extends CategoryEvent {
  final String category;
  DeleteCategoryEvent(this.category);
}

class SelectCategoryEvent extends CategoryEvent {
  final String category;
  SelectCategoryEvent(this.category);
}
