part of 'category_bloc.dart';

enum CategoryStatus { initial, loading, success, failure }

@immutable
final class CategoryState {
  const CategoryState({
    this.status = CategoryStatus.initial,
    this.categories = const [],
    this.message,
    this.isSyncing = false,
  });

  final CategoryStatus status;
  final List<CategoryItem> categories;
  final String? message;
  final bool isSyncing;

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryItem>? categories,
    String? message,
    bool? isSyncing,
  }) => CategoryState(
    status: status ?? this.status,
    categories: categories ?? this.categories,
    message: message ?? this.message,
    isSyncing: isSyncing ?? this.isSyncing,
  );
}
