import 'base_service.dart';

// Interface for authentication service
abstract class AuthService {
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password, String name);
  Future<void> logout();
  bool isLoggedIn();
  String? getCurrentUserId();
}

// Implementation of authentication service
class AuthServiceImpl implements AuthService {
  final PersistenceService _persistenceService;

  // Key for storing user data
  static const String _userKey = 'current_user';

  // Singleton instance
  static final AuthServiceImpl _instance = AuthServiceImpl._internal(
    ServiceFactory().getPersistenceService()
  );

  factory AuthServiceImpl() {
    return _instance;
  }

  AuthServiceImpl._internal(this._persistenceService);

  @override
  String? getCurrentUserId() {
    // In a real implementation, this would retrieve the user ID from storage
    return 'user123';
  }

  @override
  bool isLoggedIn() {
    // In a real implementation, this would check if the user is logged in
    return getCurrentUserId() != null;
  }

  @override
  Future<bool> login(String email, String password) async {
    // In a real implementation, this would validate credentials against a backend
    // For now, we'll just simulate a successful login
    await Future.delayed(const Duration(seconds: 1));

    // Store user data
    await _persistenceService.saveData(_userKey, {
      'id': 'user123',
      'email': email,
      'name': 'Test User',
    });

    return true;
  }

  @override
  Future<void> logout() async {
    // Clear user data
    await _persistenceService.removeData(_userKey);
  }

  @override
  Future<bool> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));

    // Store user data
    await _persistenceService.saveData(_userKey, {
      'id': 'user123',
      'email': email,
      'name': name,
    });

    return true;
  }
}
