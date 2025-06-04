import 'dart:async';

// Base class for all BLoC events
abstract class BlocEvent {}

// Base class for all BLoC states
abstract class BlocState {}

// Base class for all BLoCs
abstract class Bloc<E extends BlocEvent, S extends BlocState> {
  // Stream controller for the state
  final _stateController = StreamController<S>.broadcast();

  // Stream of states
  Stream<S> get state => _stateController.stream;

  // Current state
  S? _currentState;
  S? get currentState => _currentState;

  // Method to handle events
  void dispatch(E event);

  // Method to emit a new state
  void emit(S state) {
    _currentState = state;
    _stateController.add(state);
  }

  // Method to dispose resources
  void dispose() {
    _stateController.close();
  }
}

// BLoC provider for dependency injection
class BlocProvider<T extends Bloc> {
  static final Map<Type, Bloc> _blocs = {};

  static T get<T extends Bloc>() {
    return _blocs[T] as T;
  }

  static void register<T extends Bloc>(T bloc) {
    _blocs[T] = bloc;
  }

  static void dispose<T extends Bloc>() {
    if (_blocs.containsKey(T)) {
      _blocs[T]!.dispose();
      _blocs.remove(T);
    }
  }

  static void disposeAll() {
    _blocs.forEach((_, bloc) => bloc.dispose());
    _blocs.clear();
  }
}
