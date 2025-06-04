
// Base interface for all controllers
abstract class BaseController {
  void dispose();
}

// Interface for controllers that need to initialize data
abstract class InitializableController extends BaseController {
  Future<void> initialize();
}

// Base controller implementation
abstract class Controller implements BaseController {
  @override
  void dispose() {
    // Clean up resources
  }

  // Additional common controller methods can be added here
}

// Base controller implementation with initialization
abstract class InitializableControllerImpl implements InitializableController {
  @override
  Future<void> initialize() async {
    // Default implementation
  }

  @override
  void dispose() {
    // Clean up resources
  }
}
