import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseController {
  void dispose();

  Future<void> initialize();

  void handleError(String message, [Object? error]);
}

abstract class BlocController<T> extends Cubit<T> implements BaseController {
  BlocController(super.initialState);

  @override
  void dispose() {
    super.close();
  }

  @override
  Future<void> initialize() async {
  }

  @override
  void handleError(String message, [Object? error]) {

  }
}

abstract class CallbackController implements BaseController {
  @override
  void dispose() {
  }

  @override
  Future<void> initialize() async {
  }

  @override
  void handleError(String message, [Object? error]) {
  }
}
