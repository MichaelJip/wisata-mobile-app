part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

class CategorySynced extends CategoryEvent {}

class CategoryLocalFetched extends CategoryEvent {}
