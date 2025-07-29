import 'package:flutter_bloc/flutter_bloc.dart';

/// Base interface for all controllers that provides common functionality
abstract class BaseController {
  /// Clean up resources when controller is no longer needed
  void dispose();
  
  /// Initialize the controller and load initial data
  Future<void> initialize();
}

/// Base controller implementation for BLoC-based controllers
abstract class BlocController<T> extends Cubit<T> implements BaseController {
  BlocController(super.initialState);
  
  @override
  void dispose() {
    super.close();
  }
  
  @override
  Future<void> initialize() async {
    // Default implementation - override in subclasses
  }
}

/// Base controller implementation for callback-based controllers
abstract class CallbackController implements BaseController {
  @override
  void dispose() {
    // Default implementation - override in subclasses
  }
  
  @override
  Future<void> initialize() async {
    // Default implementation - override in subclasses
  }
}
