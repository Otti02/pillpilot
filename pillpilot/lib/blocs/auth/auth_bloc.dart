import '../../blocs/base_bloc.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

// Auth events
abstract class AuthEvent extends BlocEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  RegisterEvent({
    required this.email,
    required this.password,
    required this.name,
  });
}

class LogoutEvent extends AuthEvent {}

// Auth states
abstract class AuthState extends BlocState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final User user;

  AuthAuthenticatedState({required this.user});
}

class AuthUnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState({required this.message});
}

// Auth BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService {
    // Set initial state
    emit(AuthInitialState());
  }

  @override
  void dispatch(AuthEvent event) async {
    if (event is LoginEvent) {
      await _handleLogin(event);
    } else if (event is RegisterEvent) {
      await _handleRegister(event);
    } else if (event is LogoutEvent) {
      await _handleLogout();
    }
  }

  Future<void> _handleLogin(LoginEvent event) async {
    emit(AuthLoadingState());

    try {
      final success = await _authService.login(
        event.email,
        event.password,
      );

      if (success) {
        final userId = _authService.getCurrentUserId();
        if (userId != null) {
          final user = User(
            id: userId,
            email: event.email,
            name: 'Test User', // In a real app, this would come from the backend
          );
          emit(AuthAuthenticatedState(user: user));
        } else {
          emit(AuthErrorState(message: 'Failed to get user data'));
        }
      } else {
        emit(AuthErrorState(message: 'Invalid credentials'));
      }
    } catch (e) {
      emit(AuthErrorState(message: 'Login failed: ${e.toString()}'));
    }
  }

  Future<void> _handleRegister(RegisterEvent event) async {
    emit(AuthLoadingState());

    try {
      final success = await _authService.register(
        event.email,
        event.password,
        event.name,
      );

      if (success) {
        final userId = _authService.getCurrentUserId();
        if (userId != null) {
          final user = User(
            id: userId,
            email: event.email,
            name: event.name,
          );
          emit(AuthAuthenticatedState(user: user));
        } else {
          emit(AuthErrorState(message: 'Failed to get user data'));
        }
      } else {
        emit(AuthErrorState(message: 'Registration failed'));
      }
    } catch (e) {
      emit(AuthErrorState(message: 'Registration failed: ${e.toString()}'));
    }
  }

  Future<void> _handleLogout() async {
    emit(AuthLoadingState());

    try {
      await _authService.logout();
      emit(AuthUnauthenticatedState());
    } catch (e) {
      emit(AuthErrorState(message: 'Logout failed: ${e.toString()}'));
    }
  }
}
