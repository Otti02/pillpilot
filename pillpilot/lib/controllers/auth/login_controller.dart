import '../../controllers/base_controller.dart';
import '../../services/auth_service.dart';
import '../../services/service_provider.dart';
import '../../router.dart';

// Login controller
class LoginController extends InitializableControllerImpl {
  final AuthService _authService;

  // Callback functions for view updates
  void Function()? onLoadingStart;
  void Function()? onLoadingEnd;
  void Function(String)? onError;
  void Function()? onLoginSuccess;

  LoginController()
      : _authService = ServiceProvider().authService;

  @override
  Future<void> initialize() async {
    // Initialization logic if needed
  }

  // Login with email and password
  Future<void> login(String email, String password) async {
    if (!_validateInput(email, password)) {
      return;
    }

    try {
      // Show loading
      onLoadingStart?.call();

      // Attempt login
      final success = await _authService.login(email, password);

      // Hide loading
      onLoadingEnd?.call();

      if (success) {
        // Navigate to home on success
        onLoginSuccess?.call();
        AppRouter.instance.goToHome();
      } else {
        // Show error on failure
        onError?.call('Login failed. Please check your credentials.');
      }
    } catch (e) {
      // Hide loading and show error on exception
      onLoadingEnd?.call();
      onError?.call('An error occurred: ${e.toString()}');
    }
  }

  // Validate login input
  bool _validateInput(String email, String password) {
    if (email.isEmpty) {
      onError?.call('Email is required');
      return false;
    }

    if (!_isValidEmail(email)) {
      onError?.call('Invalid email format');
      return false;
    }

    if (password.isEmpty) {
      onError?.call('Password is required');
      return false;
    }

    return true;
  }

  // Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Navigate to register screen
  void navigateToRegister() {
    AppRouter.instance.goToRegister();
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}
