import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';
import 'package:wisata_app/core/utils/either.dart';
import 'package:wisata_app/data/datasources/category_local_datasource.dart';
import 'package:wisata_app/data/datasources/category_remote_datasource.dart';
import 'package:wisata_app/data/models/response/category_response_model.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc(this._remote, this._local) : super(const CategoryState()) {
    on<CategorySynced>(_onSynced, transformer: droppable());
    on<CategoryLocalFetched>(_onLocalFetched, transformer: restartable());
    _watchConnectivity();
  }

  final CategoryRemoteDatasource _remote;
  final CategoryLocalDatasource _local;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  bool _isOnline(List<ConnectivityResult> results) =>
      !results.contains(ConnectivityResult.none);

  Future<void> _watchConnectivity() async {
    final connectivity = Connectivity();
    var wasOnline = _isOnline(await connectivity.checkConnectivity());

    _connectivitySub = connectivity.onConnectivityChanged.listen((results) {
      final online = _isOnline(results);
      if (online && !wasOnline) add(CategorySynced());
      wasOnline = online;
    });
  }

  @override
  Future<void> close() {
    _connectivitySub?.cancel();
    return super.close();
  }

  Future<void> _onLocalFetched(
    CategoryLocalFetched event,
    Emitter<CategoryState> emit,
  ) async {
    final categories = await _local.getCategories();
    if (categories.isEmpty) return;
    emit(
      state.copyWith(status: CategoryStatus.success, categories: categories),
    );
  }

  Future<void> _onSynced(
    CategorySynced event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        isSyncing: true,
        status: state.categories.isEmpty
            ? CategoryStatus.loading
            : state.status,
      ),
    );

    final result = await _remote.getAllCategories();

    switch (result) {
      case Left(:final value):
        final local = await _local.getCategories();
        if (local.isEmpty) {
          emit(
            state.copyWith(
              status: CategoryStatus.failure,
              message: value,
              isSyncing: false,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: CategoryStatus.success,
              categories: local,
              isSyncing: false,
            ),
          );
        }
      case Right(:final value):
        await _local.replaceAll(value);

        emit(
          state.copyWith(
            status: CategoryStatus.success,
            categories: await _local.getCategories(),
            isSyncing: false,
          ),
        );
    }
  }
}
