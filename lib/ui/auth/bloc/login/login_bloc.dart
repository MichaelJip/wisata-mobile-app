import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wisata_app/core/utils/either.dart';
import 'package:wisata_app/data/datasources/auth_remote_datasource.dart';
import 'package:wisata_app/data/models/request/login_request_model.dart';
import 'package:wisata_app/data/models/response/login_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._datasource, this._local) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      final result = await _datasource.login(event.request);
      switch (result) {
        case Left(:final value):
          emit(LoginFailure(value));
        case Right(:final value):
          await _local.saveToken(value.token ?? '');
          emit(LoginSuccess(value));
      }
    });
  }

  final AuthRemoteDatasource _datasource;
  final AuthLocalDataResource _local;
}
